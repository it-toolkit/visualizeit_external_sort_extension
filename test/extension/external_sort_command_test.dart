import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';

class ExternalSortModelMock extends Mock implements ExternalSortModel {}

class CommandContextMock extends Mock implements CommandContext {}

void main() {
  var externalSortModelMock = ExternalSortModelMock();
  var resultExternalSortModelMock = ExternalSortModelMock();
  var commandContextMock = CommandContextMock();

  tearDown(() => reset(externalSortModelMock));
  group("sort command tests - ", () {
    test("sort command construction", () {
      var command = SortCommand("modelName");

      expect(command.uuid, isNotEmpty);
      expect(command.modelName, equals("modelName"));
    });
    test("sort command call on a model that has no pending frame", () {
      var command = SortCommand("modelName");
      when(() => externalSortModelMock.executeCommand(command))
          .thenReturn((0, resultExternalSortModelMock));
      when(() => externalSortModelMock.clone())
          .thenReturn(externalSortModelMock);

      var commandResult =
          command.call(externalSortModelMock, commandContextMock);

      expect(commandResult.finished, isTrue);
      expect(commandResult.model,
          allOf(isA<ExternalSortModel>(), equals(resultExternalSortModelMock)));
    });

    test("sort command call on a model that keeps ongoing", () {
      var command = SortCommand("modelName");
      when(() => externalSortModelMock.executeCommand(command))
          .thenReturn((4, resultExternalSortModelMock));
      when(() => externalSortModelMock.clone())
          .thenReturn(externalSortModelMock);

      var commandResult =
          command.call(externalSortModelMock, commandContextMock);

      expect(commandResult.finished, isFalse);
      expect(commandResult.model,
          allOf(isA<ExternalSortModel>(), equals(resultExternalSortModelMock)));
    });
  });

  group("merge command tests", () {
    test("merge command construction", () {
    var command = MergeCommand("modelName");

    expect(command.uuid, isNotEmpty);
    expect(command.modelName, equals("modelName"));
  });

  test("merge command call on a model that has no pending frame", () {
    var command = MergeCommand("modelName");
    when(() => externalSortModelMock.executeCommand(command))
        .thenReturn((0, resultExternalSortModelMock));
    when(() => externalSortModelMock.clone()).thenReturn(externalSortModelMock);

    var commandResult = command.call(externalSortModelMock, commandContextMock);

    expect(commandResult.finished, isTrue);
    expect(commandResult.model,
        allOf(isA<ExternalSortModel>(), equals(resultExternalSortModelMock)));
  });

  test("merge command call on a model that has keeps ongoing", () {
    var command = MergeCommand("modelName");
    when(() => externalSortModelMock.executeCommand(command))
        .thenReturn((4, resultExternalSortModelMock));
    when(() => externalSortModelMock.clone()).thenReturn(externalSortModelMock);

    var commandResult = command.call(externalSortModelMock, commandContextMock);

    expect(commandResult.finished, isFalse);
    expect(commandResult.model,
        allOf(isA<ExternalSortModel>(), equals(resultExternalSortModelMock)));
  });
   });

  
}
