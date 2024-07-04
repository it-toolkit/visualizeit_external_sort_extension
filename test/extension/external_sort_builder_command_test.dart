import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_builder_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';

class CommandContextMock extends Mock implements CommandContext {}

void main() {
  var commandContextMock = CommandContextMock();

  test("Call test", () {
    var command = ExternalSortBuilderCommand(3, 5, [1, 2, 3, 4]);

    var model = command.call(commandContextMock);
    expect(model.extensionId, ExternalSortExtension.extensionId);
    expect(model.name, "");
    expect(model.bufferSize, 3);
    expect(model.fragmentLimit, 5);
    expect(model.fileToSort, containsAll([1, 2, 3, 4]));
    expect(model.commandInExecution, isNull);
    expect(model.currentTransition, isNull);
  });

  test("Buffer size limit Error less than min", () {
    var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
      1,
      5,
      ["1", "2", "3", "4"]
    ]);

    expect(
        () => ExternalSortBuilderCommand.build(rawCommand),
        throwsA(allOf(
            isException,
            predicate(
                (e) => e.toString().contains("'bufferSize' must be in range")))));
  });

  test("Buffer size Error more than max", () {
    var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
      16,
      5,
      ["1", "2", "3", "4"]
    ]);

    expect(
        () => ExternalSortBuilderCommand.build(rawCommand),
        throwsA(allOf(
            isException,
            predicate(
                (e) => e.toString().contains("'bufferSize' must be in range")))));
  });


  test("Fragment limit Error less than min", () {
    var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
      3,
      1,
      ["1", "2", "3", "4"]
    ]);

    expect(
        () => ExternalSortBuilderCommand.build(rawCommand),
        throwsA(allOf(
            isException,
            predicate(
                (e) => e.toString().contains("'fragmentLimit' must be in range")))));
  });

  test("Fragment limit Error more than max", () {
    var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
      3,
      11,
      ["1", "2", "3", "4"]
    ]);

    expect(
        () => ExternalSortBuilderCommand.build(rawCommand),
        throwsA(allOf(
            isException,
            predicate(
                (e) => e.toString().contains("'fragmentLimit' must be in range")))));
  });

  test("File to sort size must be greater than buffer size", () {
    var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
      5,
      3,
      ["1", "2", "3", "4"]
    ]);

    expect(
        () => ExternalSortBuilderCommand.build(rawCommand),
        throwsA(allOf(
            isException,
            predicate(
                (e) => e.toString().contains("File must have more keys than buffer size")))));
  });
}
