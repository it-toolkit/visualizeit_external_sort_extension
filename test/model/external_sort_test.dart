import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort.dart';

void main() {
  group("sort tests", () {
    test("sort with file not empty", () {
      var valuesToSort = [
        410,
        425,
        656,
        427,
        434,
        446,
        973,
        264,
        453,
        466,
        717,
        738,
        477,
        221,
        486,
        497,
        503,
        62,
        985,
        220,
        508,
        481,
        514,
        515,
        529,
        538,
        552,
        144,
        414,
        202
      ];
      var externalsort = ExternalSort<num>(valuesToSort, 5, 3);
      var fragments = externalsort.sort();

      List<num> allFragmentsKey = [];
      for (var fragment in fragments) {
        print(fragment);
        expect(fragment.isSorted(), true);
        allFragmentsKey.addAll(fragment);
      }

      expect(allFragmentsKey, hasLength(valuesToSort.length));
      expect(allFragmentsKey, containsAll(valuesToSort));
    });

    test("sort with empty file", () {
      List<num> valuesToSort = [];
      var externalsort = ExternalSort<num>(valuesToSort, 5, 3);
      expect(() => externalsort.sort(), throwsArgumentError);
    });

    test("sort with file with less keys than buffer", () {
      List<num> valuesToSort = [2, 7, 8];
      var externalsort = ExternalSort<num>(valuesToSort, 5, 3);
      expect(() => externalsort.sort(), throwsArgumentError);
    });

    test("random values sorting", () {
      Random random = Random();
      Set<num> setOfNums = {};
      while (setOfNums.length < 80) {
        setOfNums.add(random.nextInt(1000));
      }

      List<num> valuesToSort = setOfNums.toList();

      var externalsort = ExternalSort<num>(valuesToSort, 5, 3);
      var fragments = externalsort.sort();

      List<num> allFragmentsKey = [];
      for (var fragment in fragments) {
        print(fragment);
        expect(fragment.isSorted(), true);
        allFragmentsKey.addAll(fragment);
      }

      expect(allFragmentsKey, hasLength(valuesToSort.length));
      expect(allFragmentsKey, containsAll(valuesToSort));
    });
  });

  group("merge sorted files", () {
    test("merge with less fragments than fragment limit", () {
      List<num> fragment1 = [
        410,
        425,
        427,
        434,
        446,
        453,
        466,
        656,
        717,
        738,
        973
      ];
      List<num> fragment2 = [
        221,
        264,
        477,
        486,
        497,
        503,
        508,
        514,
        515,
        529,
        538,
        552,
        985
      ];
      var externalsort = ExternalSort<num>([12, 13, 14], 5, 3);
      externalsort.fragments = [fragment1, fragment2];
      List<num> sortedFile = externalsort.merge();
      expect(sortedFile.isSorted(), true);
      expect(sortedFile, hasLength(fragment1.length + fragment2.length));
      expect(sortedFile, containsAll(fragment1));
      expect(sortedFile, containsAll(fragment2));
    });

    test("merge more fragments than fragment limit", () {
      List<List<num>> fragmentsToMerge = [
        [40, 216, 458, 635, 791, 792, 797, 815, 900],
        [43, 96, 253, 294, 689, 808, 891, 898, 943],
        [25, 85, 527, 817, 873, 908, 953],
        [13, 247, 250, 296, 328, 342, 430, 639, 825, 928, 973],
        [230, 564, 578, 625, 632, 760, 835],
        [82, 181, 184, 196, 353, 415, 505, 545, 803, 859, 906],
        [136, 205, 235, 259, 314, 448, 781, 790, 913]
      ];
      var externalsort = ExternalSort<num>([12, 13, 14], 5, 3);
      externalsort.fragments = fragmentsToMerge;
      List<num> sortedFile = externalsort.merge();
      expect(sortedFile.isSorted(), true);
      expect(
          sortedFile,
          hasLength(fragmentsToMerge.fold<int>(
              0, (previousValue, element) => previousValue + element.length)));
      expect(
          sortedFile,
          containsAll(fragmentsToMerge.fold<List>([], (previousValue, element) {
            previousValue.addAll(element);
            return previousValue;
          })));
    });
  });
}
