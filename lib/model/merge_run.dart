import 'package:collection/collection.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/observable.dart';

class MergeRun<T extends Comparable<T>> extends Observable {
  final List<List<T>> _currentFragments;
  final List<List<T>> _nextRuns;
  final int _batchStart, _batchFinish;
  Logger logger = Logger("extension.externalsort.mergerun");

  MergeRun(this._currentFragments, this._batchStart, this._batchFinish,
      this._nextRuns);

  List<T> merge() {
    final fragmentsToMerge =
        _currentFragments.sublist(_batchStart, _batchFinish);
    notifyObservers(MergeTransition<T>.batchSelected(
        _currentFragments.map((e) => List.of(e)).toList(),
        fragmentsToMerge.map((e) => List.of(e)).toList(),
        _batchStart,
        _batchFinish,
        _nextRuns.map((e) => List.of(e)).toList()));

    // Define a priority queue to always get the smallest element
    final priorityQueue = PriorityQueue<QueueEntry<T>>();
    final List<T> result = [];

    // Initialize the priority queue with the first element of each fragment
    for (int i = 0; i < fragmentsToMerge.length; i++) {
      if (fragmentsToMerge[i].isNotEmpty) {
        priorityQueue
            .add(QueueEntry<T>(fragmentsToMerge[i][0], _batchStart + i, 0));
      }
    }

    notifyObservers(MergeTransition<T>.priorityQueueInitialized(
        _currentFragments.map((e) => List.of(e)).toList(),
        fragmentsToMerge.map((e) => List.of(e)).toList(),
        priorityQueue.toList(),
        [],
        _batchStart,
        _batchFinish,
        _nextRuns.map((e) => List.of(e)).toList()));

    // Process the priority queue until it's empty.
    while (priorityQueue.isNotEmpty) {
      // Get the smallest element from the queue.
      final smallestEntry = priorityQueue.removeFirst();
      result.add(smallestEntry.value);

      // Get the next element from the same fragment, if it exists
      final nextIndex = smallestEntry.currentKeyPointer + 1;
      if (nextIndex < fragmentsToMerge[smallestEntry.fragmentIndex - _batchStart].length) {
        priorityQueue.add(QueueEntry<T>(
            fragmentsToMerge[smallestEntry.fragmentIndex - _batchStart][nextIndex],
            smallestEntry.fragmentIndex,
            nextIndex));
      }
      notifyObservers(MergeTransition<T>.mergeRunResultAdded(
          _currentFragments.map((e) => List.of(e)).toList(),
          fragmentsToMerge.map((e) => List.of(e)).toList(),
          priorityQueue.toList(),
          List.of(result),
          _batchStart,
          _batchFinish,
          _nextRuns.map((e) => List.of(e)).toList()));
    }
    logger.trace(() => "Run result: $result");

    return result;
  }
}

class QueueEntry<T extends Comparable<T>> implements Comparable<QueueEntry<T>> {
  final T value;
  final int fragmentIndex;
  final int currentKeyPointer;

  QueueEntry(this.value, this.fragmentIndex, this.currentKeyPointer);

  @override
  int compareTo(QueueEntry<T> other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() {
    return "QueueEntry(value:$value, fragment:$fragmentIndex, currentKey:$currentKeyPointer)";
  }
}
