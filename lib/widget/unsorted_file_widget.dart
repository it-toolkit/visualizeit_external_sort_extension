import 'package:flutter/material.dart';

class UnsortedFileWidget extends StatefulWidget {
  final List<num> fileToSort;
  final int? unsortedFilePointer;
  final Map<num, Color> mapOfColors;

  const UnsortedFileWidget(this.fileToSort, this.unsortedFilePointer, this.mapOfColors,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _UnsortedFileWidgetState();
  }
}

class _UnsortedFileWidgetState extends State<UnsortedFileWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 80, maxHeight: 50),
          child: const Text("File to Order"),
        )
      ],
    ));

    rows.addAll(buildValueBox(widget.fileToSort, widget.unsortedFilePointer));
    return Column(
      children: rows,
    );
  }

  List<Widget> buildValueBox(List<num> fileToSort, int? unsortedFilePointer) {
    List<Widget> valueBoxes = [];

    for (var i = 0; i < fileToSort.length; i++) {

      var borderColor = Colors.black;
      var textColor = Colors.black;
      var fontWeight = FontWeight.normal;
      double containerWidth = 80;
      var borderWidth = 1.0;
      if (unsortedFilePointer != null && unsortedFilePointer == i) {
        borderColor = Colors.blueGrey;
        textColor = Colors.white;
        borderWidth = 2.0;
        fontWeight = FontWeight.bold;
        containerWidth = 90;
      }

      valueBoxes.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: containerWidth,
            height: 25,
            margin: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              color: widget.mapOfColors[fileToSort[i]]
            ),
            child: Text(
              fileToSort[i].toString(),
              style: TextStyle(color: textColor, fontWeight: fontWeight),
            ),
          )
        ],
      ));
    }

    /*for (var element in fileToSort) {
      valueBoxes.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 80,
            height: 20,
            margin: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(),
              color: getColorFromValue(element, fileToSort.length),
            ),
            child: Text(element.toString()),
          )
        ],
      ));
    }*/
    return valueBoxes;
  }

}
