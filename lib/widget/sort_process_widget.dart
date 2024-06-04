import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/model/index_array.dart';

class SortProcessWidget extends StatefulWidget {
  final ExternalSortTransition<num>? _transition;
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: buildBuffer(widget._bufferSize, widget._transition?.buffer,
              widget._transition?.bufferPositionToReplace),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: buildIndexArray(
                widget._bufferSize,
                widget._transition?.buffer,
                widget._transition?.indexArray,
                widget._transition?.bufferPositionToReplace)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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

    bufferComponents.add(
      Container(
          height: 72,
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: bufferSize,
            itemBuilder: (context, index) =>
                bufferValueBuider(bufferSize, buffer, index, bufferPositionToReplace),
          )),
    );

    return bufferComponents;
  }

  Widget bufferValueBuider(int bufferSize, List<num>? buffer, int index,
      int? bufferPositionToReplace) {
    var numToShow = " ";
    Color backgroundColor = Colors.white;
    if(buffer!= null){
      numToShow = buffer[index].toString();
      backgroundColor = widget.mapOfColors[buffer[index]]!;
    }
    
    Container bufferBox = buildColoredBox(index, numToShow,
        backgroundColor, bufferPositionToReplace);

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0.0,
        title: Container(
            width: 40,
            height: 20,
            alignment: Alignment.bottomCenter,
            child: Text(
              index.toString(),
              style: const TextStyle(fontSize: 12),
            )),
        subtitle: bufferBox,
      ),
    );
  }

  List<Widget> buildIndexArray(int bufferSize, List<num>? buffer, IndexArray<num>? indexArray,
      int? bufferPositionToReplace) {
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

      indexArrayComponents.add(
        Container(
            height: 72,
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: bufferSize,
              itemBuilder: (context, index) => indexArrayValueBuider(indexArray, index, bufferPositionToReplace),
            )),
      );

    return indexArrayComponents;
  }

  Container buildColoredBox(int index, String numToShow, Color backgroundColor,
      [int? positionToEnhance]) {
    var borderColor = Colors.black;
    var textColor = Colors.black;
    var fontWeight = FontWeight.normal;
    double containerHeight = 40;
    double containerWidth = 40;
    var borderWidth = 1.0;

    if (positionToEnhance != null && positionToEnhance == index) {
      borderColor = Colors.blueGrey;
      textColor = Colors.white;
      borderWidth = 2.0;
      fontWeight = FontWeight.bold;
      containerHeight = 50;
      containerWidth = 50;
    }

    var coloredBox = Container(
      width: containerWidth,
      height: containerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        color: backgroundColor,
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          numToShow,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
    return coloredBox;
  }

  Widget indexArrayValueBuider( IndexArray<num>? indexArray,
      int index, int? bufferPositionToReplace) {
    var maybeEntry = indexArray?.entries.elementAt(index);
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

    var indexBox = buildColoredBox(
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

    var indexArrayValue = buildColoredBox(
        index,
        key != null ? key.toString() : " ",
        indexArrayValueBoxColor,
        positionToHighlight);

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0.0,
        title: indexArrayValue,
        subtitle: indexBox,
      ),
    );
  }

  List<Widget> buildFragments(
      List<List<num>>? fragments, int? currentFragment) {
    List<Widget> fragmentsComponent = [];

    fragmentsComponent.add(Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: 105.0,
      alignment: Alignment.centerRight,
      child: const Text(
        "Fragments",
        style: TextStyle(fontSize: 20.0),
      ),
    ));

    List<Widget> fragmentsRow = [buildFragmentRow(0, [], 0)];
    if(fragments != null ){
      fragmentsRow = fragments
                .mapIndexed((index, fragment) =>
                    buildFragmentRow(index, fragment, currentFragment))
                .toList();
    }

      var fragmentsContainer = Container(
        constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
        decoration: BoxDecoration(border: Border.all()),
        padding: const EdgeInsets.only(right: 5.0),
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fragmentsRow,
      ));
      fragmentsComponent.add(fragmentsContainer);

    return fragmentsComponent;
  }

  Widget buildFragmentRow(int index, List<num> fragment, int? currentFragment) {
    var textStyle = const TextStyle(fontSize: 15.0);
    if (index == currentFragment) {
      textStyle = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          alignment: Alignment.center,
          width: 30,
          child: Text(
            "F$index",
            style: textStyle,
          ),
        ),
        Container(
            height: 50,
            //padding: const EdgeInsets.only(top: 5.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: fragment.length,
              itemBuilder: (context, idx) =>
                  fragmentValueBuider(fragment, currentFragment, idx),
            ))
      ],
    );
  }

  Widget fragmentValueBuider(
      List<num> fragment, int? currentFragment, int index) {
    var numToShow = fragment[index];
    Container fragmentBox = buildColoredBox(
        index, numToShow.toString(), widget.mapOfColors[numToShow]!);

    return Container(
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
    );
  }
}
