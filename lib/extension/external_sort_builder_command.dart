import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';

class ExternalSortBuilderCommand extends ModelBuilderCommand {
  static final commandDefinition = CommandDefinition(
      ExternalSortExtension.extensionId, "externalsort-create", [
    CommandArgDef("bufferSize", ArgType.int),
    CommandArgDef("fragmentLimit", ArgType.int),
    CommandArgDef("fileToSort", ArgType.intArray)
  ]);

  final List<int> fileToSort;
  final int bufferSize;
  final int fragmentLimit;

  ExternalSortBuilderCommand(
      this.bufferSize, this.fragmentLimit, this.fileToSort);
  ExternalSortBuilderCommand.build(RawCommand rawCommand)
      : bufferSize = _getIntArgInRange(name: "bufferSize", from: rawCommand, min: 2, max: 30),
        fragmentLimit =  _getIntArgInRange(name: "fragmentLimit", from: rawCommand, min: 2, max: 30),
        fileToSort = (commandDefinition.getArg(name: "fileToSort", from: rawCommand) as List<int>);

  @override
  ExternalSortModel call(CommandContext context) {
    return ExternalSortModel("", bufferSize, fragmentLimit, fileToSort);
  }

  static _getIntArgInRange({required String name, required RawCommand from, required int min, required int max}) {
    int value = commandDefinition.getArg(name: name, from: from);
    if (value < min || value > max) throw Exception("Value must be in range [ $min , $max ]");

    return value;
  }
}
