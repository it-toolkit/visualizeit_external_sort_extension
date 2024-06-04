import 'package:flutter/material.dart';

class UnsortedFileWidget extends StatefulWidget {
  final List<num> fileToSort;
  final int? unsortedFilePointer;
  final Map<num, Color> mapOfColors;

  const UnsortedFileWidget(
      this.fileToSort, this.unsortedFilePointer, this.mapOfColors,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _UnsortedFileWidgetState();
  }
}

class _UnsortedFileWidgetState extends State<UnsortedFileWidget> {
  late ScrollController _scrollController;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    double initialOffSet = 0.0;
    if (widget.unsortedFilePointer != null) {
      initialOffSet = widget.unsortedFilePointer!.toDouble();
    }
    _scrollController = ScrollController(
        initialScrollOffset: initialOffSet, keepScrollOffset: false);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(
      const SizedBox(
        height: 25,
        width: 80,
        child: Text("File to Order"),
      ),
    );

    rows.add(
      Expanded(
        child: SingleChildScrollView(
          controller: _scrollController,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                buildValueBox(widget.fileToSort, widget.unsortedFilePointer),
          ),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {

    if (widget.unsortedFilePointer != null) {
      var position = widget.unsortedFilePointer!.toDouble();
      //TODO mejorar esta logica
      if(position > 8.0){
        _scrollController.animateTo(position * 25, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      }
    }
    });

    
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

      valueBoxes.add(Container(
        width: containerWidth,
        height: 25,
        margin: const EdgeInsets.fromLTRB(30, 1, 30, 1),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            color: widget.mapOfColors[fileToSort[i]]),
        child: Text(
          fileToSort[i].toString(),
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
      ));
    }
    return valueBoxes;
  }
}
