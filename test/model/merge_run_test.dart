import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visualizeit_external_sort_extension/model/merge_run.dart';

void main() {
  test("merge run", () {
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
    List<num> fragment3 = [62, 144, 202, 220, 414, 481];

    var mergeRun = MergeRun<num>([fragment1, fragment2, fragment3],0,3, []);

    var fragmentMerged = mergeRun.merge();
    expect(fragmentMerged.isSorted(), true);
    expect(fragmentMerged,
        hasLength(fragment1.length + fragment2.length + fragment3.length));
    expect(fragmentMerged, containsAll(fragment1));
    expect(fragmentMerged, containsAll(fragment2));
    expect(fragmentMerged, containsAll(fragment3));
  });

  test("merge with only one fragment", () {
    List<num> fragment1 = [410, 425, 427, 434, 446, 453];

    var mergeRun = MergeRun<num>([fragment1],0,1,[]);

    var fragmentMerged = mergeRun.merge();

    expect(fragmentMerged.isSorted(), true);
    expect(fragmentMerged,
        hasLength(fragment1.length));
    expect(fragmentMerged, containsAll(fragment1));
  });
}
