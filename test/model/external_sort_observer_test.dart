import 'package:flutter_test/flutter_test.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort_observer.dart';

void main() {
  test("sort test with observer", () {
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
      var observer = ExternalSortObserver();
      externalsort.registerObserver(observer);
      externalsort.sort();

      expect(observer.transitions, isNotEmpty);
  });
}