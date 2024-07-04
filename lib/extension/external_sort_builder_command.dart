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

  late List<int> fileToSort;
  late int bufferSize;
  late int fragmentLimit;

  ExternalSortBuilderCommand(
      this.bufferSize, this.fragmentLimit, this.fileToSort);
  ExternalSortBuilderCommand.build(RawCommand rawCommand){
    bufferSize = _getIntArgInRange(name: "bufferSize", rawCommand: rawCommand, min: 2, max: 15);
    fragmentLimit = _getIntArgInRange(name: "fragmentLimit", rawCommand: rawCommand, min: 2, max: 10);
    fileToSort = _validate(name: "fileToSort", rawCommand: rawCommand, bufferSize: bufferSize);
  }

  @override
  ExternalSortModel call(CommandContext context) {
    return ExternalSortModel("", bufferSize, fragmentLimit, fileToSort);
  }

  static _getIntArgInRange({required String name, required RawCommand rawCommand, required int min, required int max}) {
    int value = commandDefinition.getArg(name: name, from: rawCommand);
    if (value < min || value > max) throw Exception("Value must be in range [ $min , $max ]");

    return value;
  }
  
  static _validate({required String name, required RawCommand rawCommand, required int bufferSize}) {
    var fileToSort = commandDefinition.getArg(name: "fileToSort", from: rawCommand) as List<int>;

    if(fileToSort.length <= bufferSize){
      throw Exception("File must have more keys than buffer size");
    }
    return fileToSort;
  }
}
