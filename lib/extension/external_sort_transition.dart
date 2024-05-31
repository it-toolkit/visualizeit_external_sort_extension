import 'package:visualizeit_external_sort_extension/model/index_array.dart';

class ExternalSortTransition<T> {
  final TransitionType _type;
  final List<T> _fileToSort;
  final List<List<T>> _fragments;
  final List<T> _buffer;
  int? _unsortedFilePointer;
  int? _fragmentIndex;
  IndexArray? _indexArray;
  int? _bufferPositionToReplace;

  TransitionType get type => _type;
  List<T> get fileToSort => _fileToSort;
  List<List<T>> get fragments => _fragments;
  List<T> get buffer => _buffer;
  int? get unsortedFilePointer => _unsortedFilePointer;
  int? get fragmentIndex => _fragmentIndex;
  IndexArray? get indexArray => _indexArray;
  int? get bufferPositionToReplace => _bufferPositionToReplace;

  ExternalSortTransition(
      this._type,
      this._fileToSort,
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._fragmentIndex,
      this._indexArray,
      this._bufferPositionToReplace);

  ExternalSortTransition.bufferFilled(this._fileToSort, this._fragments,
      this._buffer, this._unsortedFilePointer)
      : _type = TransitionType.bufferFilled;
  ExternalSortTransition.indexArrayBuilt(this._fileToSort, this._fragments,
      this._buffer, this._unsortedFilePointer, this._indexArray)
      : _type = TransitionType.indexArrayBuilt;
  ExternalSortTransition.indexArrayFrozen(
      this._fileToSort,
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex)
      : _type = TransitionType.indexArrayFrozen;
  ExternalSortTransition.replacedEntry(
      this._fileToSort,
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      _bufferPositionToReplace)
      : _type = TransitionType.replacedEntry;
  ExternalSortTransition.frozenEntry(
      this._fileToSort,
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      _bufferPositionToReplace)
      : _type = TransitionType.frozenEntry;
  ExternalSortTransition.fileToSortEnded(
    this._fileToSort,
    this._fragments,
    this._buffer,
  )
  //this._unsortedFilePointer,
  //this._indexArray,
  //this._fragmentIndex,
  //_bufferPositionToReplace)
  : _type = TransitionType.fileToSortEnded;
}

enum TransitionType {
  bufferFilled,
  indexArrayBuilt,
  replacedEntry,
  frozenEntry,
  indexArrayFrozen,
  fileToSortEnded
}
