import 'package:flutter/src/widgets/framework.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/extension.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_extensions/visualizer.dart';

final _logger = Logger("extension.externalsort");

class ExternalSortExtensionBuilder extends ExtensionBuilder {
  static const _docsLocationPath =
      "packages/visualizeit_external_sort_extension/assets/docs";
  static const _availableDocsLanguages = [LanguageCodes.en];

  @override
  Future<Extension> build() async {
    _logger.trace(() => "Building B# Tree extension");
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

  ExternalSortExtension() : super({});
  @override
  Widget? render(Model model, BuildContext context) {
    // TODO: implement render
    throw UnimplementedError();
  }
}
