import 'package:uuid/uuid.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_model.dart';

abstract class ExternalSortCommand extends ModelCommand {
  final String uuid;
  final Logger _logger;

  ExternalSortCommand(this.uuid, this._logger, super.modelName);

  @override
  Result call(Model model, CommandContext context) {
    ExternalSortModel externalSortModel = (model.clone()) as ExternalSortModel;

    int pendingFrames;
    Model? resultModel;

    (pendingFrames, resultModel) = externalSortModel.executeCommand(this);

    var result = Result(finished: pendingFrames == 0, model: resultModel);

    _logger.info(() => "command result: $result");

    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is ExternalSortCommand) {
      if (runtimeType == other.runtimeType) {
        if (uuid == other.uuid) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([uuid, modelName]);
}

class SortCommand extends ExternalSortCommand {
  static final commandDefinition = CommandDefinition(
      ExternalSortExtension.extensionId, "externalsort-sort", []);

  SortCommand(String modelName)
      : super(const Uuid().v4(), Logger("extension.externalsort.sort"),
            modelName);

  SortCommand.build(RawCommand rawCommand)
      : super(const Uuid().v4(), Logger("extension.externalsort.merge"), "");
}

class MergeCommand extends ExternalSortCommand {
  static final commandDefinition = CommandDefinition(
      ExternalSortExtension.extensionId, "externalsort-merge", []);

  MergeCommand(String modelName)
    : super(const Uuid().v4(), Logger("extension.externalsort.merge"),
            modelName);
}
