import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_command.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_extension.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort_observer.dart';

class ExternalSortModel extends Model {
  final ExternalSort<num> _externalSort;
  List<ExternalSortTransition<num>> _transitions = [];
  ExternalSortCommand? commandInExecution;
  int _currentFrame = 0;

  ExternalSortTransition<num>? get currentTransition =>
      _transitions.isNotEmpty ? _transitions[_currentFrame] : null;
  int get _pendingFrames => _transitions.length - _currentFrame - 1;

  List<num> get fileToSort => _externalSort.fileToSort;
  int get bufferSize => _externalSort.bufferSize;

  ExternalSortModel(
      String name, int bufferSize, int fragmentLimit, List<int> fileToSort)
      : _externalSort =
            ExternalSort<num>(fileToSort, bufferSize, fragmentLimit),
        super(ExternalSortExtension.extensionId, name);

  ExternalSortModel.copyWith(
      this._externalSort,
      this._currentFrame,
      this.commandInExecution,
      this._transitions,
      super.extensionId,
      super.name);

  (int, Model) executeCommand(ExternalSortCommand command) {
    if (_canExecuteCommand(command)) {
      if (isInTransition()) {
        _currentFrame++;
      } else {
        commandInExecution = command;
        _currentFrame = 0;
        var transitionObserver = ExternalSortObserver<num>();
        _externalSort.registerObserver(transitionObserver);
        if (command is SortCommand) {
          _externalSort.sort();
        } else {
          _externalSort.merge();
        }
        _transitions = transitionObserver.transitions;
        _externalSort.removeObserver(transitionObserver);
      }
      return (_pendingFrames, this);
    } else {
      throw UnsupportedError(
          "cant execute a command while another command is on transition");
    }
  }

  bool _canExecuteCommand(ExternalSortCommand command) {
    return (commandInExecution != command && !isInTransition()) ||
        (commandInExecution == command && isInTransition());
  }

  bool isInTransition() {
    return _transitions.isNotEmpty && _currentFrame < _transitions.length - 1;
  }

  @override
  Model clone() {
    return ExternalSortModel.copyWith(_externalSort.clone(), _currentFrame,
        commandInExecution, List.of(_transitions), extensionId, name);
  }
}
