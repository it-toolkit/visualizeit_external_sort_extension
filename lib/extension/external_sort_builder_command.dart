import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';

class ExternalSortBuilderCommand extends ModelBuilderCommand {
  static final commandDefinition = CommandDefinition(
      ExternalSortExtension.extensionId, "externalsort-create", [
    CommandArgDef("bufferSize", ArgType.int),
    CommandArgDef("fragmentLimit", ArgType.int),
    CommandArgDef("fileToSort", ArgType.stringArray)
  ]);

  final List<int> fileToSort;
  final int bufferSize;
  final int fragmentLimit;

  ExternalSortBuilderCommand(
      this.bufferSize, this.fragmentLimit, this.fileToSort);
  ExternalSortBuilderCommand.build(RawCommand rawCommand)
      : bufferSize =
            commandDefinition.getArg(name: "bufferSize", from: rawCommand),
        fragmentLimit =
            commandDefinition.getArg(name: "fragmentLimit", from: rawCommand),
        fileToSort = (commandDefinition.getArg(
                name: "fileToSort", from: rawCommand) as List<String>)
            .map(int.parse)
            .toList();

  @override
  Model call(CommandContext context) {
    return ExternalSortModel("", bufferSize, fragmentLimit, fileToSort);
  }
}
