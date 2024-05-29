import 'package:collection/collection.dart';
import 'package:visualizeit_extensions/logging.dart';

class MergeRun<T extends Comparable<T>> {

  final List<List<T>> _fragmentsToMerge;
  Logger logger = Logger("extension.externalsort.mergerun");

  MergeRun(this._fragmentsToMerge);

  List<T> merge() {
    // Define a priority queue to always get the smallest element.
    final priorityQueue = PriorityQueue<_QueueEntry<T>>();
    final List<T> result = [];

    // Initialize the priority queue with the first element of each run.
    for (int i = 0; i < _fragmentsToMerge.length; i++) {
      if (_fragmentsToMerge[i].isNotEmpty) {
        priorityQueue.add(_QueueEntry<T>(_fragmentsToMerge[i][0], i, 0));
      }
    }

    // Process the priority queue until it's empty.
    while (priorityQueue.isNotEmpty) {
      // Get the smallest element from the queue.
      final smallestEntry = priorityQueue.removeFirst();
      result.add(smallestEntry.value);

      // Get the next element from the same run, if it exists.
      final nextIndex = smallestEntry.currentKeyPointer + 1;
      if (nextIndex < _fragmentsToMerge[smallestEntry.fragmentIndex].length) {
        priorityQueue.add(_QueueEntry<T>(
            _fragmentsToMerge[smallestEntry.fragmentIndex][nextIndex],
            smallestEntry.fragmentIndex,
            nextIndex));
      }
    }
    logger.debug(() => "Run result: $result");
    return result;
  }
}

class _QueueEntry<T extends Comparable<T>> implements Comparable<_QueueEntry<T>>{
  final T value;
  final int fragmentIndex;
  final int currentKeyPointer;

  _QueueEntry(this.value, this.fragmentIndex, this.currentKeyPointer);
  
  @override
  int compareTo(_QueueEntry<T> other) {
    return value.compareTo(other.value);
  }
}
