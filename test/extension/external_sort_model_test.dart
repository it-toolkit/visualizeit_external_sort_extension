import 'package:flutter_test/flutter_test.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';

void main() {
  test("External Sort Model creation", () {
    var externalSortModel = ExternalSortModel("name", 2, 6, [3, 4, 5, 6]);

    expect(externalSortModel.name, equals("name"));
    expect(externalSortModel.bufferSize, 2);
    expect(externalSortModel.fragmentLimit, 6);
    expect(externalSortModel.fileToSort, containsAll([3, 4, 5, 6]));
    expect(externalSortModel.commandInExecution, isNull);
    expect(externalSortModel.currentTransition, isNull);
  });

  group("command execution", () {
    test("sort command execution", () {
      var fileToSort = [
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
      ];
      var externalSortModel = ExternalSortModel("name", 5, 3, fileToSort);
      int pendingFrames;
      Model modelAfterExecution;

      (pendingFrames, modelAfterExecution) = externalSortModel
          .executeCommand(SortCommand("modelName"));

      expect(pendingFrames, greaterThan(0));
      expect(modelAfterExecution, isA<ExternalSortModel>());
      expect(
          (modelAfterExecution as ExternalSortModel).isInTransition(),
          isTrue);
    });

    test("merge command execution", () {
      var fileToSort = [
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
      ];
      var externalSortModel = ExternalSortModel("name", 5, 3, fileToSort);
      int pendingFrames;
      ExternalSortModel modelAfterSort;
      Model modelAfterMerge;
      var sortCommand = SortCommand("modelName");

      do {
        (pendingFrames, modelAfterSort as ExternalSortModel) = externalSortModel.executeCommand(sortCommand);
      } while (pendingFrames > 0);

      expect(pendingFrames, 0);
      expect(modelAfterSort.isInTransition(), isFalse);


      (pendingFrames, modelAfterMerge) = externalSortModel
          .executeCommand(MergeCommand("modelName"));

      expect(pendingFrames, greaterThan(0));
      expect(modelAfterMerge, isA<ExternalSortModel>());
      expect(
          (modelAfterMerge as ExternalSortModel).isInTransition(),
          isTrue);
    });

    test("try to execute another command while in transition ", () {
      var fileToSort = [
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
      ];
      var externalSortModel = ExternalSortModel("name", 5, 3, fileToSort);
      int pendingFrames;
      ExternalSortModel modelAfterExecution;

      (pendingFrames, modelAfterExecution as ExternalSortModel) = externalSortModel
          .executeCommand(SortCommand("modelName"));

      expect(pendingFrames, greaterThan(0));
      expect(() => modelAfterExecution.executeCommand(SortCommand("modelName")),
      throwsA(const TypeMatcher<UnsupportedError>()));
    });

    test("execute until transitions are over", () {
      var fileToSort = [
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
      ];
      var externalSortModel = ExternalSortModel("name", 5, 3, fileToSort);
      int pendingFrames;
      Model modelAfterExecution;
      var commandToExecute = SortCommand("modelName");

      do {
        (pendingFrames, modelAfterExecution) = externalSortModel.executeCommand(commandToExecute);
      } while (pendingFrames > 0);

      expect(pendingFrames, 0);
      expect(modelAfterExecution, isA<ExternalSortModel>());
    });
  });
}
