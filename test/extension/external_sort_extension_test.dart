import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_builder_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/widget/external_sort_widget.dart';

class ExternalSortModelMock extends Mock implements ExternalSortModel {}

class AnotherModelMock extends Mock implements Model {}

class BuildContextMock extends Mock implements BuildContext {}

void main() {
  var extension = ExternalSortExtension();
  var externalSortModelMock = ExternalSortModelMock();
  var buildContextMock = BuildContextMock();
  var anotherModelMock = AnotherModelMock();

  group("Extension tests - ", () {
    test("command definitions must be 3", () {
      expect(
          extension.getAllCommandDefinitions(),
          allOf(
              hasLength(3),
              containsAll([
                ExternalSortBuilderCommand.commandDefinition,
                SortCommand.commandDefinition,
                MergeCommand.commandDefinition,
              ])));
    });

    test("build external sort creation command", () {
      var rawCommand = RawCommand.withPositionalArgs("externalsort-create", [
        5,
        3,
        ["1", "2", "3", "4"]
      ]);
      var maybeCommand = extension.buildCommand(rawCommand);
      expect(maybeCommand, allOf(isNotNull, isA<ExternalSortBuilderCommand>()));
      var builderCommand = maybeCommand as ExternalSortBuilderCommand;
      expect(builderCommand.bufferSize, 5);
      expect(builderCommand.fragmentLimit, 3);
      expect(builderCommand.fileToSort, containsAll([1, 2, 3, 4]));
    });

    test("build external sort command", () {
      var rawCommand = RawCommand.withPositionalArgs("externalsort-sort", []);
      var maybeCommand = extension.buildCommand(rawCommand);
      expect(maybeCommand, allOf(isNotNull, isA<SortCommand>()));
    });

    test("build external merge command", () {
      var rawCommand = RawCommand.withPositionalArgs("externalsort-merge", []);
      var maybeCommand = extension.buildCommand(rawCommand);
      expect(maybeCommand, allOf(isNotNull, isA<MergeCommand>()));
    });

    test("non existent command", () {
      var rawCommand = RawCommand.literal("im-non-existent");
      var maybeCommand = extension.buildCommand(rawCommand);
      expect(maybeCommand, isNull);
    });

    test("render an ExternalSort Model", () {
      when(()=>externalSortModelMock.currentTransition).thenReturn(SortTransition.bufferFilled([], null, null));
      when(()=>externalSortModelMock.bufferSize).thenReturn(3);
      when(()=>externalSortModelMock.fragmentLimit).thenReturn(3);
      when(()=>externalSortModelMock.fileToSort).thenReturn([11, 12, 13, 14]);
      var maybeWidget = extension.render(externalSortModelMock, buildContextMock);
      expect(maybeWidget, allOf(isNotNull, isA<ExternalSortWidget>()));
    }); 

    test("render another Model", () {
      expect(extension.render(anotherModelMock, buildContextMock), isNull);
    });
  });
}
