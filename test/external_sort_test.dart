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
      while (setOfNums.length < 50) {
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
}
