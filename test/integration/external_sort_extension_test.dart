import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_extensions/visualizer.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_builder_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';
import 'package:visualizeit_external_sort_extension/widget/merge_process_widget.dart';
import 'package:visualizeit_external_sort_extension/widget/sort_process_widget.dart';
import 'package:visualizeit_external_sort_extension/widget/unsorted_file_widget.dart';

class BuildContextMock extends Mock implements BuildContext {}

void main() {
  var buildContextMock = BuildContextMock();
  var createRawCommand = RawCommand.withPositionalArgs("externalsort-create", [
    5,
    3,
    [
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
    ]
  ]);
  var sortRawCommand = RawCommand.withPositionalArgs("externalsort-sort", []);
  var mergeRawCommand = RawCommand.withPositionalArgs("externalsort-merge", []);

  var extensionBuilder = ExternalSortExtensionBuilder();

  testWidgets("test external sort", (tester) async {
    var extension = await extensionBuilder.build();
    ScriptingExtension scriptingExtension = extension.scripting;
    VisualizerExtension visualizerExtension = extension.visualizer;

    ExternalSortBuilderCommand? createCommand = scriptingExtension
        .buildCommand(createRawCommand) as ExternalSortBuilderCommand?;
    SortCommand? sortCommand =
        scriptingExtension.buildCommand(sortRawCommand) as SortCommand?;

    ExternalSortModel model = createCommand!.call(CommandContext());
    Result result = sortCommand!.call(model, CommandContext());
    model = result.model as ExternalSortModel;

    var externalSortWidget =
        visualizerExtension.render(model, buildContextMock);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: InteractiveViewer(
        clipBehavior: Clip.none,
        child: externalSortWidget!,
      ),
    )));

    await tester.pumpAndSettle();

    expect(result.finished, false);
    expect(model, isNotNull);
    expect(find.byType(SortProcessWidget), findsOneWidget);
    expect(find.byType(UnsortedFileWidget), findsOneWidget);
    expect(find.byType(MergeProcessWidget), findsNothing);
    expect(find.text("221"), findsOne);
  });

  testWidgets("test external merge", (tester) async {
    var extension = await extensionBuilder.build();
    ScriptingExtension scriptingExtension = extension.scripting;
    VisualizerExtension visualizerExtension = extension.visualizer;

    ExternalSortBuilderCommand? createCommand = scriptingExtension
        .buildCommand(createRawCommand) as ExternalSortBuilderCommand?;
    SortCommand? sortCommand =
        scriptingExtension.buildCommand(sortRawCommand) as SortCommand?;
    MergeCommand? mergeCommand =
        scriptingExtension.buildCommand(mergeRawCommand) as MergeCommand?;

    Model? model = createCommand!.call(CommandContext());

    Result result;
    do {
      result = sortCommand!.call(model!, CommandContext());
      model = result.model;
    } while (!result.finished);
    
    result = mergeCommand!.call(result.model!, CommandContext());

    model = result.model as ExternalSortModel;

    var externalSortWidget =
        visualizerExtension.render(model, buildContextMock);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: InteractiveViewer(
        clipBehavior: Clip.none,
        child: externalSortWidget!,
      ),
    )));

    await tester.pumpAndSettle();

    expect(result.finished, false);
    expect(model, isNotNull);
    expect(find.byType(SortProcessWidget), findsNothing);
    expect(find.byType(UnsortedFileWidget), findsOneWidget);
    expect(find.byType(MergeProcessWidget), findsOneWidget);
    expect(find.text("221"), findsExactly(2));
  });
}
