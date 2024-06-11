import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_builder_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';

class CommandContextMock extends Mock implements CommandContext {}

void main(){
  var commandContextMock = CommandContextMock();

   test("Call test", () {
    var command = ExternalSortBuilderCommand(3, 5, [1, 2, 3, 4]);

    var model = command.call(commandContextMock);
    expect(model.extensionId, ExternalSortExtension.extensionId);
    expect(model.name,
        ""); //TODO arreglar este test cuando entienda que es el name
    expect(model.bufferSize, 3);
    expect(model.fragmentLimit, 5);
    expect(model.fileToSort, containsAll([1, 2, 3, 4]));
    expect(model.commandInExecution, isNull);
    expect(model.currentTransition, isNull);
  });
}