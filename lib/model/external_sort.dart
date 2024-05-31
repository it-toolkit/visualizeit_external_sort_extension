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
  List<T> orderedFile = [];
  Logger logger = Logger("extension.externalsort.model");

  ExternalSort(this.fileToSort, this.bufferSize, this.fragmentLimit);

  List<List<T>> sort() {
    validateParameters();
    // Buffer initialization
    int unsortedFilePointer = bufferSize - 1;
    List<T> buffer = fileToSort.getRange(0, bufferSize).toList();

    notifyObservers(ExternalSortTransition<T>.bufferFilled(
        fileToSort, fragments, buffer, unsortedFilePointer));

    //IndexArray initialization
    IndexArray<T> indexArray = IndexArray<T>(buffer
        .mapIndexed((index, key) => IndexArrayEntry(key, index))
        .toList());

    notifyObservers(ExternalSortTransition<T>.indexArrayBuilt(
        fileToSort, fragments, buffer, unsortedFilePointer, indexArray));

    int fragmentIndex = 0;
    do {
      //Removes first unfrozen entry
      var entryToWrite = indexArray.removeFirstUnfrozen();

      //There's at least one unfrozen entry in the index array
      if (entryToWrite != null) {
        fragments[fragmentIndex].add(entryToWrite.key);
        logger.debug(() => "wrote key to file: ${entryToWrite.key}");

        // Check if the unsorted file still has keys to add to the buffer
        unsortedFilePointer++;
        if (unsortedFilePointer < fileToSort.length) {
          int bufferPositionToReplace = entryToWrite.bufferPosition;
          logger.debug(
              () => "buffer position to replace: $bufferPositionToReplace");
          //Gets a new key from the unsorted file
          var keyToAddToBuffer = fileToSort[unsortedFilePointer];
          logger.debug(() => "new key to add to the buffer: $keyToAddToBuffer");

          //Replaces the entry in the buffer with the new key
          buffer[bufferPositionToReplace] = keyToAddToBuffer;

          //Adds the key to the index array, checking to see if it needs to froze it
          addNewKeyToIndexArray(keyToAddToBuffer, entryToWrite, indexArray,
              bufferPositionToReplace);
          notifyObservers(ExternalSortTransition<T>.replacedEntry(
              fileToSort,
              fragments,
              buffer,
              unsortedFilePointer,
              indexArray,
              fragmentIndex,
              bufferPositionToReplace));
        } else {
          //There's no more keys to sort, so we pass the remaining keys to a new fragment
          //If the last added to file is bigger than the first in the index array we need a new fragment
          logger.debug(() => "Remaining entries: ${indexArray.entries}");
          if (fragments[fragmentIndex]
                  .last
                  .compareTo(indexArray.entries.first.key) >
              0) {
            fragmentIndex++;
            fragments.add([]);
            notifyObservers(ExternalSortTransition<T>.indexArrayFrozen(
                fileToSort,
                fragments,
                buffer,
                unsortedFilePointer,
                indexArray,
                fragmentIndex));
          }
          fragments[fragmentIndex].addAll(indexArray.removeRemainingKeys());
          notifyObservers(
              ExternalSortTransition<T>.fileToSortEnded(fileToSort, fragments, buffer));
        }
      }
      //Checks if all entries are frozen, if they are, starts a new fragment
      if (!indexArray.hasUnfrozenEntries()) {
        fragmentIndex++;
        indexArray.unfrozeAllEntries();
        fragments.add([]); //New fragment created
        notifyObservers(ExternalSortTransition<T>.indexArrayFrozen(fileToSort,
            fragments, buffer, unsortedFilePointer, indexArray, fragmentIndex));
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
      logger.debug(() => "new key is lower than last key wrote to fragment");
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

    while (currentFragments.length > 1) {
      List<List<T>> nextRuns = [];
      for (int i = 0; i < currentFragments.length; i += fragmentLimit) {
        final batch = currentFragments.sublist(
            i,
            (i + fragmentLimit > currentFragments.length)
                ? currentFragments.length
                : i + fragmentLimit);
        final mergedRun = MergeRun(batch).merge();
        nextRuns.add(mergedRun);
      }
      currentFragments = nextRuns;
    }

    orderedFile = currentFragments.isEmpty ? [] : currentFragments.first;
    return orderedFile;
  }

  void validateParameters() {
    if (fileToSort.isEmpty) {
      throw ArgumentError("No keys in the file to sort");
    }

    if (bufferSize > fileToSort.length) {
      throw ArgumentError("file length should be greater than buffer size");
    }
  }
}
