import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/merge_run.dart';
import 'package:visualizeit_external_sort_extension/widget/colored_box.dart';

class MergeProcessWidget extends StatefulWidget {
  final MergeTransition<num>? _transition;
  final int fragmentLimit;
  final Map<num, Color> mapOfColors;

  const MergeProcessWidget(
      this._transition, this.fragmentLimit, this.mapOfColors,
      {super.key});

  @override
  State<MergeProcessWidget> createState() => _MergeProcessWidgetState();
}

class _MergeProcessWidgetState extends State<MergeProcessWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Check if there are any fragments that need to be highlighted
    List<int>? fragmentIndexes;
    int? batchStart = widget._transition?.batchStart;
    int? batchFinish = widget._transition?.batchFinish;
    if (batchStart != null && batchFinish != null) {
      fragmentIndexes = List<int>.generate(
          batchFinish - batchStart, (index) => batchStart + index);
    }

    List<Widget> rows = [];
    var currentTransition = widget._transition;
    if (currentTransition != null) {
      if (currentTransition.type == TransitionType.mergeFinished) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: buildBatch("Sorted File", currentTransition.sortedFile),
        ));
      } else {
        rows.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: buildCurrentFragments(
                "Fragments",
                currentTransition.currentFragments,
                currentTransition.priorityQueue,
                fragmentIndexes),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: buildBatch("Merge Run", currentTransition.mergeRunResult),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: buildNextRun("Next run", currentTransition.nextRuns),
          )
        ]);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  List<Widget> buildCurrentFragments(
      String sectionLabel,
      List<List<num>>? fragments,
      List<QueueEntry<num>>? priorityQueue,
      List<int>? fragmentIndexes) {
    List<Widget> fragmentsComponent = [];

    fragmentsComponent.add(Container(
      margin: const EdgeInsets.all(10),
      width: 105.0,
      alignment: Alignment.centerRight,
      child: Text(
        sectionLabel,
        style: const TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> fragmentsRow = [buildFragmentRow(0, [], fragmentLabel: "F0")];

    if (fragments != null) {
      fragmentsRow = fragments
          .mapIndexed((index, fragment) => buildFragmentRow(index, fragment,
              fragmentLabel: "F$index",
              fragmentIndexes: fragmentIndexes,
              positionToHighlight:
                  getPositionToHighlight(index, priorityQueue, fragmentIndexes?.max)))
          .toList();
    }

    var fragmentsContainer = Flexible(
      child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
          decoration: BoxDecoration(border: Border.all()),
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fragmentsRow,
          )),
    );
    fragmentsComponent.add(fragmentsContainer);
    return fragmentsComponent;
  }

  List<Widget> buildBatch(String sectionLabel, List<num>? mergeRunResult) {
    List<Widget> fragmentsComponent = [];

    fragmentsComponent.add(Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: 105.0,
      height: 80,
      alignment: Alignment.centerRight,
      child: Text(
        sectionLabel,
        style: const TextStyle(fontSize: 20.0),
      ),
    ));

    var fragmentsContainer = Flexible(
        child: Container(
            constraints: const BoxConstraints(minWidth: 100, minHeight: 50),
            decoration: BoxDecoration(border: Border.all()),
            padding: const EdgeInsets.only(top: 5.0, right: 5.0),
            margin: const EdgeInsets.only(left: 10, top: 10),
            child:
                buildFragmentRow(0, mergeRunResult, fragmentLabel: "Result")));
    fragmentsComponent.add(fragmentsContainer);

    return fragmentsComponent;
  }

  int? getPositionToHighlight(int index, List<QueueEntry<num>>? priorityQueue, int? maxFragmentIndex) {
    int? position;
    if (priorityQueue != null) {
      var queueEntryForIndex = priorityQueue
          .firstWhereOrNull((entry) => entry.fragmentIndex == index);
      if(queueEntryForIndex != null){
        position = queueEntryForIndex.currentKeyPointer;
      } else {
        if(maxFragmentIndex!=null && index <= maxFragmentIndex){
          position = 999;
        }
      }
    }

    return position;
  }

  List<Widget> buildNextRun(String sectionLabel, List<List<num>>? fragments) {
    List<Widget> fragmentsComponent = [];

    fragmentsComponent.add(Container(
      margin: const EdgeInsets.all(10.0),
      width: 105.0,
      alignment: Alignment.centerRight,
      child: Text(
        sectionLabel,
        style: const TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> fragmentsRow = [buildFragmentRow(0, [], fragmentLabel: "F0")];
    if (fragments != null) {
      fragmentsRow = fragments
          .mapIndexed((index, fragment) => buildFragmentRow(
                index,
                fragment,
                fragmentLabel: "F$index",
              ))
          .toList();
    }

    var fragmentsContainer = Flexible(
      child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
          decoration: BoxDecoration(border: Border.all()),
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fragmentsRow,
          )),
    );
    fragmentsComponent.add(fragmentsContainer);

    return fragmentsComponent;
  }

  Widget buildFragmentRow(int index, List<num>? fragment,
      {String? fragmentLabel,
      List<int>? fragmentIndexes,
      int? positionToHighlight}) {
    List<Widget> rowsContent = [];

    if (fragmentLabel != null) {
      var textStyle = const TextStyle(fontSize: 15.0);
      if (fragmentIndexes != null && fragmentIndexes.contains(index)) {
        textStyle =
            const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
      }

      rowsContent.add(Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        width: 30,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            fragmentLabel,
            style: textStyle,
          ),
        ),
      ));
    }

    List<Widget> valueBoxes = [];
    if (fragment != null) {
      valueBoxes.addAll(fragment
          .mapIndexed((index, element) =>
              fragmentValueBuider(fragment, index, positionToHighlight))
          .toList());
    }

    rowsContent.add(Flexible(
        child: Wrap(
      clipBehavior: Clip.antiAlias,
      direction: Axis.horizontal,
      children: valueBoxes,
    )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: rowsContent,
    );
  }

  Widget fragmentValueBuider(
      List<num> fragment, int index, int? positionToHighlight) {
    var numToShow = fragment[index];
    Color boxColor = widget.mapOfColors[numToShow]!;

    if (positionToHighlight != null) {
      if (index < positionToHighlight) {
        boxColor = Colors.grey;
      }
    }

    var fragmentBox = ColoredValueBox(
      index,
      numToShow.toString(),
      boxColor,
      positionToHighlight: positionToHighlight,
    );

    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.topCenter,
      child: fragmentBox,
    );
    //return fragmentBox;
  }
}
