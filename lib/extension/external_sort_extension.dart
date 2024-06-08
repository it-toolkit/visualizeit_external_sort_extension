import 'package:flutter/material.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/extension.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_extensions/visualizer.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_builder_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';
import 'package:visualizeit_external_sort_extension/widget/external_sort_widget.dart';

final _logger = Logger("extension.externalsort");

class ExternalSortExtensionBuilder extends ExtensionBuilder {
  static const _docsLocationPath =
      "packages/visualizeit_external_sort_extension/assets/docs";
  static const _availableDocsLanguages = [LanguageCodes.en];

  @override
  Future<Extension> build() async {
    _logger.trace(() => "Building External Sort extension");
    var extension = ExternalSortExtension();

    final markdownDocs = {
      for (final languageCode in _availableDocsLanguages)
        languageCode: '$_docsLocationPath/$languageCode.md'
    };

    return Extension(
        ExternalSortExtension.extensionId, extension, extension, markdownDocs);
  }
}

class ExternalSortExtension extends DefaultScriptingExtension
    implements ScriptingExtension, VisualizerExtension {
  static const extensionId = "externalsort-extension";

  ExternalSortExtension()
      : super({
          ExternalSortBuilderCommand.commandDefinition:
              ExternalSortBuilderCommand.build,
          SortCommand.commandDefinition: SortCommand.build,
          MergeCommand.commandDefinition: MergeCommand.build,
        });
  @override
  Widget? render(Model model, BuildContext context) {
    if (model is ExternalSortModel) {
      return ExternalSortWidget(
            model.fileToSort, model.bufferSize, model.fragmentLimit, model.currentTransition);
    } else {
      return null;
    }
  }
}
