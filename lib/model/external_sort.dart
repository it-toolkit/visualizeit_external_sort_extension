import 'package:collection/collection.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_external_sort_extension/model/index_array.dart';
import 'package:visualizeit_external_sort_extension/model/merge_run.dart';

class ExternalSort<T extends Comparable<T>> {
  final List<T> fileToSort;
  final int bufferSize;
  final int fragmentAmount;

  List<List<T>> fragments = [[]];
  List<T> orderedFile = [];
  Logger logger = Logger("extension.externalsort.model");

  ExternalSort(this.fileToSort, this.bufferSize, this.fragmentAmount);

  List<List<T>> sort() {
    validateParameters();
    // Buffer initialization
    int unorderedFilePointer = bufferSize - 1;
    List<T> buffer = fileToSort.getRange(0, bufferSize).toList();

    //IndexArray initialization
    IndexArray<T> indexArray = IndexArray<T>(buffer
        .mapIndexed((index, key) => IndexArrayEntry(key, index))
        .toList());
    int fragmentIndex = 0;
    do {
      //Checks if all entries are frozen, if they are, starts a new fragment
      if (!indexArray.hasUnfrozenEntries()) {
        fragmentIndex++;
        indexArray.unfrozeAllEntries();
        fragments.add([]); //New fragment created
      }

      //Removes first unfrozen entry
      var entryToWrite = indexArray.removeFirstUnfrozen();

      //There's at least one unfrozen entry in the index array
      if (entryToWrite != null) {
        fragments[fragmentIndex].add(entryToWrite.key);
        logger.debug(() => "wrote key to file: ${entryToWrite.key}");

        // Check if the unordered file still has keys to add to the buffer
        unorderedFilePointer++;
        if (unorderedFilePointer < fileToSort.length) {
          int bufferPositionToReplace = entryToWrite.bufferPosition;
          logger.debug(
              () => "buffer position to replace: $bufferPositionToReplace");
          //Gets a new key from the unordered file
          var keyToAddToBuffer = fileToSort[unorderedFilePointer];
          logger.debug(() => "new key to add to the buffer: $keyToAddToBuffer");

          //Replaces the entry in the buffer with the new key
          buffer[bufferPositionToReplace] = keyToAddToBuffer;

          //Adds the key to the index array, checking to see if it needs to froze it
          addNewKeyToIndexArray(keyToAddToBuffer, entryToWrite, indexArray,
              bufferPositionToReplace);
        } else {
          //There's no more keys to order, so we pass the remaining keys to the fragment
          logger.debug(() => "Remaining entries: ${indexArray.entries}");
          fragments[fragmentIndex].addAll(indexArray.removeRemainingKeys());
        }
      } else {
        //this shouldn't happen
        throw StateError("there's no unfrozen entry in the IndexArray ");
      }
    } while (unorderedFilePointer < fileToSort.length);

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

  bool isKeyToAddLesserThanWroteKey(T keyToAddToBuffer, T wroteKey) 
    => keyToAddToBuffer.compareTo(wroteKey) < 0;

  List<T> merge() {
    List<List<T>> currentFragments = List.from(fragments);

    while (currentFragments.length > 1) {
      List<List<T>> nextRuns = [];
      for (int i = 0; i < currentFragments.length; i += fragmentAmount) {
        final batch = currentFragments.sublist(i,
          (i + fragmentAmount > currentFragments.length) ? currentFragments.length : i + fragmentAmount);
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
