import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';

class ExternalSortObserver<T> {
  final List<ExternalSortTransition<T>> _transitions = [];

  List<ExternalSortTransition<T>> get transitions => _transitions;

  ExternalSortObserver();

  void notify(ExternalSortTransition<T> transition) {
    _transitions.add(transition);
  }
}
