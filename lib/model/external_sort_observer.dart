import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';

class ExternalSortObserver {
  final List<ExternalSortTransition> _transitions = [];

  List<ExternalSortTransition> get transitions => _transitions;

  ExternalSortObserver();

  void notify(ExternalSortTransition transition) {
    _transitions.add(transition);
  }
}
