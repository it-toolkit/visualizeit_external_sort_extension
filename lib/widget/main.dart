import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort.dart';
import 'package:visualizeit_external_sort_extension/model/external_sort_observer.dart';
import 'package:visualizeit_external_sort_extension/widget/external_sort_widget.dart';

void main() {
  var valuesToSort = [
    410,
    425,
    656,
    427,
    434,
    446,
    973,
    264,
    453,
    466,
    717,
    738,
    477,
    221,
    486,
    497,
    503,
    62,
    985,
    220,
    508,
    481,
    514,
    515,
    529,
    538,
    552,
    144,
    414,
    202
  ];
  var externalsort = ExternalSort<num>(valuesToSort, 5, 3);
  var observer = ExternalSortObserver<num>();
  externalsort.registerObserver(observer);
  externalsort.sort();

  runApp(MyApp(valuesToSort, observer.transitions[29]));
}

class MyApp extends StatelessWidget {
  final ExternalSortTransition<num> transition;
  final List<num> fileToSort;

  const MyApp(this.fileToSort, this.transition, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualize IT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: InteractiveViewer(
          clipBehavior: Clip.none,
          child: ExternalSortWidget(fileToSort, transition),
        ),
      ),
    );
  }
}
