import 'package:collection/collection.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/index_array.dart';
import 'package:visualizeit_external_sort_extension/model/merge_run.dart';
import 'package:visualizeit_external_sort_extension/model/observable.dart';

class ExternalSort<T extends Comparable<T>> extends Observable {
  final List<T> fileToSort;
  final int bufferSize;
  final int fragmentLimit;

  List<List<T>> fragments = [[]];
  List<T> sortedFile = [];
  Logger logger = Logger("extension.externalsort.model");

  ExternalSort(this.fileToSort, this.bufferSize, this.fragmentLimit);
  ExternalSort._copy(this.fileToSort, this.bufferSize, this.fragmentLimit,
      this.fragments, this.sortedFile);

  List<List<T>> sort() {
    validateParameters();
    // Buffer initialization
    int unsortedFilePointer = bufferSize - 1;
    List<T> buffer = fileToSort.getRange(0, bufferSize).toList();

    notifyObservers(SortTransition<T>.bufferFilled(
        fragments.map((e) => List.of(e)).toList(),
        List.of(buffer),
        unsortedFilePointer));

    //IndexArray initialization
    IndexArray<T> indexArray = IndexArray<T>(buffer
        .mapIndexed((index, key) => IndexArrayEntry(key, index))
        .toList());

    notifyObservers(SortTransition<T>.indexArrayBuilt(
        fragments.map((e) => List.of(e)).toList(),
        List.of(buffer),
        unsortedFilePointer,
        indexArray.clone()));

    int fragmentIndex = 0;
    do {
      //Removes first unfrozen entry
      var entryToWrite = indexArray.removeFirstUnfrozen();

      //There's at least one unfrozen entry in the index array
      if (entryToWrite != null) {
        fragments[fragmentIndex].add(entryToWrite.key);
        logger.trace(() => "wrote key to file: ${entryToWrite.key}");

        // Check if the unsorted file still has keys to add to the buffer
        unsortedFilePointer++;
        if (unsortedFilePointer < fileToSort.length) {
          int bufferPositionToReplace = entryToWrite.bufferPosition;
          logger.trace(
              () => "buffer position to replace: $bufferPositionToReplace");
          //Gets a new key from the unsorted file
          var keyToAddToBuffer = fileToSort[unsortedFilePointer];
          logger.trace(() => "new key to add to the buffer: $keyToAddToBuffer");

          //Replaces the entry in the buffer with the new key
          buffer[bufferPositionToReplace] = keyToAddToBuffer;

          //Adds the key to the index array, checking to see if it needs to froze it
          addNewKeyToIndexArray(keyToAddToBuffer, entryToWrite, indexArray,
              bufferPositionToReplace);
          notifyObservers(SortTransition<T>.replacedEntry(
              fragments.map((e) => List.of(e)).toList(),
              List.of(buffer),
              unsortedFilePointer,
              indexArray.clone(),
              fragmentIndex,
              bufferPositionToReplace));
        } else {
          //There's no more keys to sort, so we pass the remaining keys to a new fragment
          //If the last added to file is bigger than the first in the index array we need a new fragment
          logger.trace(() => "Remaining entries: ${indexArray.entries}");
          if (fragments[fragmentIndex]
                  .last
                  .compareTo(indexArray.entries.first.key) >
              0) {
            fragmentIndex++;
            fragments.add([]);
            notifyObservers(SortTransition<T>.indexArrayFrozen(
                fragments.map((e) => List.of(e)).toList(),
                List.of(buffer),
                unsortedFilePointer,
                indexArray.clone(),
                fragmentIndex));
          }
          fragments[fragmentIndex].addAll(indexArray.removeRemainingKeys());
          buffer = [];
          notifyObservers(SortTransition<T>.fileToSortEnded(
              fragments.map((e) => List.of(e)).toList()));
        }
      }
      //Checks if all entries are frozen, if they are, starts a new fragment
      if (!indexArray.isEmpty && !indexArray.hasUnfrozenEntries()) {
        fragmentIndex++;
        indexArray.unfrozeAllEntries();
        fragments.add([]); //New fragment created
        notifyObservers(SortTransition<T>.indexArrayFrozen(
            fragments.map((e) => List.of(e)).toList(),
            List.of(buffer),
            unsortedFilePointer,
            indexArray.clone(),
            fragmentIndex));
      }
    } while (unsortedFilePointer < fileToSort.length);

    return fragments;
  }

  void addNewKeyToIndexArray(
      keyToAddToBuffer,
      IndexArrayEntry<dynamic> entryToWrite,
      IndexArray<dynamic> indexArray,
      int bufferPositionToReplace) {
    if (isKeyToAddLesserThanWroteKey(keyToAddToBuffer, entryToWrite.key)) {
      logger.trace(() => "new key is lower than last key wrote to fragment");
      indexArray.addOrdered(keyToAddToBuffer, bufferPositionToReplace,
          isFrozen: true);
    } else {
      indexArray.addOrdered(keyToAddToBuffer, bufferPositionToReplace);
    }
  }

  bool isKeyToAddLesserThanWroteKey(T keyToAddToBuffer, T wroteKey) =>
      keyToAddToBuffer.compareTo(wroteKey) < 0;

  List<T> merge() {
    List<List<T>> currentFragments = List.from(fragments);

    notifyObservers(MergeTransition<T>.mergeStarted(
        currentFragments.map((e) => List.of(e)).toList()));

    while (currentFragments.length > 1) {
      List<List<T>> nextRuns = [];
      for (int i = 0; i < currentFragments.length; i += fragmentLimit) {
        var nextToProcess = (i + fragmentLimit > currentFragments.length)
            ? currentFragments.length
            : i + fragmentLimit;

        var mergeRun =
            MergeRun<T>(currentFragments, i, nextToProcess, nextRuns);

        addObserversToMergeRun(mergeRun);
        var mergeRunResult = mergeRun.merge();
        removeObserversFromMergeRun(mergeRun);

        nextRuns.add(mergeRunResult);

        notifyObservers(MergeTransition<T>.nextRunsAdded(
            currentFragments.map((e) => List.of(e)).toList(),
            nextRuns.map((e) => List.of(e)).toList()));
      }
      currentFragments = nextRuns;
      notifyObservers(MergeTransition<T>.mergeStarted(
          currentFragments.map((e) => List.of(e)).toList()));
    }

    sortedFile = currentFragments.isEmpty ? [] : currentFragments.first;
    notifyObservers(MergeTransition<T>.mergeFinished(List.of(sortedFile)));
    return sortedFile;
  }

  void validateParameters() {
    if (fileToSort.isEmpty) {
      throw ArgumentError("No keys in the file to sort");
    }

    if (bufferSize > fileToSort.length) {
      throw ArgumentError("file length should be greater than buffer size");
    }
  }

  ExternalSort<T> clone() {
    return ExternalSort<T>._copy(
        fileToSort, bufferSize, fragmentLimit, fragments, sortedFile);
  }

  void addObserversToMergeRun(MergeRun<T> mergeRun) {
    for (var observer in observers) {
      mergeRun.registerObserver(observer);
    }
  }

  void removeObserversFromMergeRun(MergeRun<T> mergeRun) {
    for (var observer in observers) {
      mergeRun.removeObserver(observer);
    }
  }
}
