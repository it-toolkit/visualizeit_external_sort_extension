import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';

class SortProcessWidget extends StatefulWidget {
  final ExternalSortTransition<num> _transition;
  final Map<num, Color> mapOfColors;

  const SortProcessWidget(this._transition, this.mapOfColors, {super.key});

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: buildBuffer(widget._transition.buffer,
              widget._transition.bufferPositionToReplace),
        ),
        /*Row(children: [buildIndexArray()]),
        Row(
          children: [buildFragments()],
        )*/
      ],
    );
  }

  List<Widget> buildBuffer(List<num> buffer, int? bufferPositionToReplace) {
    List<Widget> bufferComponents = [];
    bufferComponents.add(Container(
      margin: const EdgeInsets.all(10),
      child: const Text(
        "Buffer",
        style: TextStyle(fontSize: 20.0),
      ),
    ));

    bufferComponents.add(
      Container(
          height: 82,
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: buffer.length,
            itemBuilder: (context, index) =>
                bufferValueBuider(buffer, index, bufferPositionToReplace),
          )),
    );

    return bufferComponents;
  }

  /*Widget buildIndexArray() {}

  Widget buildFragments() {}*/

  Widget bufferValueBuider(
      List<num> buffer, int index, int? bufferPositionToReplace) {
    var borderColor = Colors.black;
    var textColor = Colors.black;
    var fontWeight = FontWeight.normal;
    double containerHeight = 40;
    double containerWidth = 40;
    var borderWidth = 1.0;
    if (bufferPositionToReplace != null && bufferPositionToReplace == index) {
      borderColor = Colors.blueGrey;
      textColor = Colors.white;
      borderWidth = 2.0;
      fontWeight = FontWeight.bold;
      containerHeight = 50;
      containerWidth = 50;
    }

    var bufferBox = Container(
      width: containerWidth,
      height: containerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        color: widget.mapOfColors[buffer[index]],
      ),
      child: Text(
        buffer[index].toString(),
        style: TextStyle(color: textColor, fontWeight: fontWeight),
      ),
    );

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
            child: Text(index.toString())),
        subtitle: bufferBox,
      ),
    );
  }
}
