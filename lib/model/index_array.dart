class IndexArray<T extends Comparable<T>> {
  final List<IndexArrayEntry<T>> entries;

  int get length => entries.length;

  IndexArray(this.entries) {
    entries.sort();
  }

  bool get isEmpty => entries.isEmpty;

  addOrdered(T key, int bufferPosition, {bool isFrozen = false}) {
    entries.add(IndexArrayEntry(key, bufferPosition, isFrozen));
    entries.sort();
  }

  bool hasUnfrozenEntries() => entries.isNotEmpty && entries.any((entry) => !entry.isFrozen);
  bool hasFrozenEntries() => entries.isNotEmpty && entries.any((entry) => entry.isFrozen);

  IndexArrayEntry<T>? removeFirstUnfrozen() {
    var firstUnfrozenPosition =
        entries.indexWhere((element) => !element.isFrozen);
    if (firstUnfrozenPosition > -1) {
      return entries.removeAt(firstUnfrozenPosition);
    } else {
      return null;
    }
  }

  List<T> removeRemainingKeys() {
    List<T> remainingKeys = [];
    for (var i = 0; i < entries.length;) {
      remainingKeys.add(entries.removeAt(i).key);
    }
    return remainingKeys;
  }

  void unfrozeAllEntries() {
    for (var entry in entries) {
      entry.isFrozen = false;
    }
  }

  IndexArray<T> clone() {
    return IndexArray(entries.map((e) => e.clone()).toList());
  }
}

class IndexArrayEntry<T extends Comparable<T>>
    implements Comparable<IndexArrayEntry<T>> {
  final T key;
  final int bufferPosition;
  bool isFrozen;

  IndexArrayEntry(this.key, this.bufferPosition, [this.isFrozen = false]);

  @override
  int compareTo(IndexArrayEntry<T> otherEntry) {
    if (!this.isFrozen && otherEntry.isFrozen) {
      return 1;
    } else if (this.isFrozen && !otherEntry.isFrozen) {
      return -1;
    }
    return this.key.compareTo(otherEntry.key);
  }

  @override
  String toString() {
    return "[ $key | $bufferPosition | ${isFrozen ? "Frozen" : ""} ]";
  }
  
  IndexArrayEntry<T> clone() {
    return IndexArrayEntry<T>(key, bufferPosition, isFrozen);
  }
}
