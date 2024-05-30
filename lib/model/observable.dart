import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort_observer.dart';

abstract class Observable {
  final List<ExternalSortObserver> observers = [];

  void registerObserver(ExternalSortObserver observer) {
    observers.add(observer);
  }
  
  void notifyObservers(ExternalSortTransition transition){
    for (var observer in observers) {
      observer.notify(transition);
    }
  }

  void removeObserver(ExternalSortObserver observer) {
    observers.removeWhere((element) => element == observer);
  }
}