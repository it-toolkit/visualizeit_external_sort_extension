import 'package:visualizeit_external_sort_extension/model/index_array.dart';
import 'package:visualizeit_external_sort_extension/model/merge_run.dart';

abstract class ExternalSortTransition<T extends Comparable<T>> {
  final TransitionType type;

  ExternalSortTransition(this.type);

  @override
  String toString() {
    return type.toString();
  }
}

class SortTransition<T extends Comparable<T>>
    extends ExternalSortTransition<T> {
  final List<List<T>> _fragments;
  List<T>? _buffer;
  int? _unsortedFilePointer;
  int? _fragmentIndex;
  IndexArray<T>? _indexArray;
  int? _bufferPositionToReplace;

  List<List<T>> get fragments => _fragments;
  List<T>? get buffer => _buffer;
  int? get unsortedFilePointer => _unsortedFilePointer;
  int? get fragmentIndex => _fragmentIndex;
  IndexArray<T>? get indexArray => _indexArray;
  int? get bufferPositionToReplace => _bufferPositionToReplace;

  SortTransition(
      super.type,
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._fragmentIndex,
      this._indexArray,
      this._bufferPositionToReplace);

  SortTransition.bufferFilled(
      this._fragments, this._buffer, this._unsortedFilePointer)
      : super(TransitionType.bufferFilled);
  SortTransition.indexArrayBuilt(this._fragments, this._buffer,
      this._unsortedFilePointer, this._indexArray)
      : super(TransitionType.indexArrayBuilt);
  SortTransition.indexArrayFrozen(this._fragments, this._buffer,
      this._unsortedFilePointer, this._indexArray, this._fragmentIndex)
      : super(TransitionType.indexArrayFrozen);
  SortTransition.replacedEntry(
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      this._bufferPositionToReplace)
      : super(TransitionType.replacedEntry);
  SortTransition.frozenEntry(
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      this._bufferPositionToReplace)
      : super(TransitionType.frozenEntry);
  SortTransition.fileToSortEnded(
    this._fragments,
  ) : super(TransitionType.fileToSortEnded);
}

class MergeTransition<T extends Comparable<T>>
    extends ExternalSortTransition<T> {
  List<List<T>>? currentFragments;
  List<List<T>>? batch;
  List<List<T>>? nextRuns;
  List<T>? sortedFile;
  int? batchStart;
  int? batchFinish;
  List<QueueEntry<T>>? priorityQueue;
  List<T>? mergeRunResult;

  MergeTransition.mergeStarted(this.currentFragments)
      : super(TransitionType.mergeStarted);
  MergeTransition.batchSelected(
      this.currentFragments, this.batch, this.batchStart, this.batchFinish, this.nextRuns)
      : super(TransitionType.batchSelected);
  MergeTransition.nextRunsAdded(this.currentFragments, this.nextRuns)
      : super(TransitionType.nextRunsAdded);
  MergeTransition.priorityQueueInitialized(this.currentFragments, this.batch,
      this.priorityQueue, this.mergeRunResult, this.batchStart, this.batchFinish, this.nextRuns)
      : super(TransitionType.priorityQueueInitialized);
  MergeTransition.mergeRunResultAdded(this.currentFragments, this.batch,
      this.priorityQueue, this.mergeRunResult, this.batchStart, this.batchFinish, this.nextRuns)
      : super(TransitionType.mergeRunResultAdded);
  MergeTransition.mergeFinished(this.sortedFile)
      : super(TransitionType.mergeFinished);
}

enum TransitionType {
  bufferFilled,
  indexArrayBuilt,
  replacedEntry,
  frozenEntry,
  indexArrayFrozen,
  fileToSortEnded,
  mergeStarted,
  batchSelected,
  nextRunsAdded,
  priorityQueueInitialized,
  mergeRunResultAdded,
  mergeFinished
}
