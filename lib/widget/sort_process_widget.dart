import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/index_array.dart';
import 'package:visualizeit_external_sort_extension/widget/colored_box.dart';

class SortProcessWidget extends StatefulWidget {
  final SortTransition<num>? _transition;
  final int _bufferSize;
  final Map<num, Color> mapOfColors;

  const SortProcessWidget(this._transition, this._bufferSize, this.mapOfColors,
      {super.key});

  @override
  State<SortProcessWidget> createState() => _SortProcessWidgetState();
}

class _SortProcessWidgetState extends State<SortProcessWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: buildBuffer(widget._bufferSize, widget._transition?.buffer,
              widget._transition?.bufferPositionToReplace),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: buildIndexArray(
                widget._bufferSize,
                widget._transition?.buffer,
                widget._transition?.indexArray,
                widget._transition?.bufferPositionToReplace)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: buildFragments(
              widget._transition?.fragments, widget._transition?.fragmentIndex),
        )
      ],
    );
  }

  List<Widget> buildBuffer(
      int bufferSize, List<num>? buffer, int? bufferPositionToReplace) {
    List<Widget> bufferComponents = [];
    bufferComponents.add(Container(
      width: 105.0,
      margin: const EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      child: const Text(
        "Buffer",
        style: TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> bufferValues = [];
    for (var i = 0; i < bufferSize; i++) {
      bufferValues.add(
          bufferValueBuider(bufferSize, buffer, i, bufferPositionToReplace));
    }

    var valueRow = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            clipBehavior: Clip.antiAlias,
            direction: Axis.horizontal,
            children: bufferValues,
          )
        ]);

    var fragmentsContainer = Flexible(
      child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 72),
          margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: valueRow),
    );
    bufferComponents.add(fragmentsContainer);

    return bufferComponents;
  }

  Widget bufferValueBuider(int bufferSize, List<num>? buffer, int index,
      int? bufferPositionToReplace) {
    var numToShow = " ";
    Color backgroundColor = Colors.white;
    if (buffer != null) {
      numToShow = buffer[index].toString();
      backgroundColor = widget.mapOfColors[buffer[index]]!;
    }

    ColoredValueBox bufferBox = ColoredValueBox(
        index, numToShow, backgroundColor,
        positionToHighlight: bufferPositionToReplace);

    return Column(
      children: [
        Container(
            width: 40,
            height: 20,
            alignment: Alignment.bottomCenter,
            child: Text(
              index.toString(),
              style: const TextStyle(fontSize: 12),
            )),
        bufferBox
      ],
    );
  }

  List<Widget> buildIndexArray(int bufferSize, List<num>? buffer,
      IndexArray<num>? indexArray, int? bufferPositionToReplace) {
    List<Widget> indexArrayComponents = [];

    indexArrayComponents.add(Container(
      margin: const EdgeInsets.all(10),
      width: 105.0,
      alignment: Alignment.centerRight,
      child: const Text(
        "Index Array",
        style: TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> indexArrayValues = [];
    for (var i = 0; i < bufferSize; i++) {
      indexArrayValues
          .add(indexArrayValueBuider(indexArray, i, bufferPositionToReplace));
    }

    var valueRow = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            clipBehavior: Clip.antiAlias,
            direction: Axis.horizontal,
            children: indexArrayValues,
          )
        ]);

    var fragmentsContainer = Flexible(
      child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 90),
          margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: valueRow),
    );
    indexArrayComponents.add(fragmentsContainer);

    return indexArrayComponents;
  }

  Widget indexArrayValueBuider(
      IndexArray<num>? indexArray, int index, int? bufferPositionToReplace) {
    IndexArrayEntry? maybeEntry;
    if (indexArray != null && index < indexArray.entries.length) {
      maybeEntry = indexArray.entries.elementAt(index);
    }

    var bufferPosition = maybeEntry?.bufferPosition;
    var key = maybeEntry?.key;

    var indexBoxColor = Colors.white;

    if (maybeEntry != null && maybeEntry.isFrozen) {
      indexBoxColor = Colors.grey;
    }

    int? positionToHighlight;

    if (bufferPosition != null && bufferPosition == bufferPositionToReplace) {
      positionToHighlight = index;
    }

    var indexBox = ColoredValueBox(
      index,
      bufferPosition != null ? bufferPosition.toString() : " ",
      indexBoxColor,
    );

    var indexArrayValueBoxColor = indexBoxColor;
    if (maybeEntry != null) {
      if (!maybeEntry.isFrozen) {
        indexArrayValueBoxColor = widget.mapOfColors[key]!;
      }
    }

    var indexArrayValue = ColoredValueBox(
        index, key != null ? key.toString() : " ", indexArrayValueBoxColor,
        positionToHighlight: positionToHighlight);

    return Column(
      children: [indexBox, indexArrayValue],
    );
  }

  List<Widget> buildFragments(
      List<List<num>>? fragments, int? currentFragment) {
    List<Widget> fragmentsComponent = [];

    fragmentsComponent.add(Container(
      margin: const EdgeInsets.all(10.0),
      width: 105.0,
      alignment: Alignment.centerRight,
      child: const Text(
        "Fragments",
        style: TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> fragmentsRow = [buildFragmentRow(0, [], 0)];
    if (fragments != null) {
      fragmentsRow = fragments
          .mapIndexed((index, fragment) =>
              buildFragmentRow(index, fragment, currentFragment))
          .toList();
    }

    var fragmentsContainer = Flexible(
        child: Container(
            constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
            decoration: BoxDecoration(border: Border.all()),
            padding: const EdgeInsets.only(top:5.0, right: 5.0),
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fragmentsRow,
            )));
    fragmentsComponent.add(fragmentsContainer);

    return fragmentsComponent;
  }

  Widget buildFragmentRow(int index, List<num> fragment, int? currentFragment) {
    var textStyle = const TextStyle(fontSize: 15.0);
    if (index == currentFragment) {
      textStyle = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    }

    List<Widget> rowsContent = [
      Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        width: 30,
        height: 30,
        child: Text(
          "F$index",
          style: textStyle,
        ),
      )
    ];

    List<Widget> valueBoxes = [];
    valueBoxes.addAll(fragment
        .mapIndexed((index, element) =>
            fragmentValueBuider(fragment, currentFragment, index))
        .toList());

    rowsContent.add(Flexible(
        child: Wrap(
      clipBehavior: Clip.antiAlias,
      direction: Axis.horizontal,
      children: valueBoxes,
    )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowsContent,
    );
  }

  Widget fragmentValueBuider(
      List<num> fragment, int? currentFragment, int index) {
    var numToShow = fragment[index];
    var fragmentBox = ColoredValueBox(
        index, numToShow.toString(), widget.mapOfColors[numToShow]!);

    /*return Container(
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0.0,
        title: fragmentBox,
      ),
    );*/
    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.topCenter,
      child: fragmentBox,
    );
  }
}
