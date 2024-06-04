import 'package:flutter/material.dart';

/*class ColoredValueBox extends StatelessWidget {
final int index;
final String textToShow;
final Color backgroundColor;
final int? positionToHighlight;

const ColoredValueBox(this.index, this.textToShow, this.backgroundColor,{this.positionToHighlight, super.key});

  @override
  Widget build(BuildContext context){
    var borderColor = Colors.black;
    var textColor = Colors.black;
    var fontWeight = FontWeight.normal;
    double containerHeight = 40;
    double containerWidth = 40;
    var borderWidth = 1.0;

    if (positionToHighlight != null && positionToHighlight == index) {
      borderColor = Colors.blueGrey;
      textColor = Colors.white;
      borderWidth = 2.0;
      fontWeight = FontWeight.bold;
      containerHeight = 50;
      containerWidth = 50;
    }

    return Container(
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
          textToShow,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
  }
}*/

class ColoredValueBox extends StatefulWidget {
final int index;
final String textToShow;
final Color backgroundColor;
final int? positionToHighlight;

const ColoredValueBox(this.index, this.textToShow, this.backgroundColor,{this.positionToHighlight, super.key});

@override
  State<ColoredValueBox> createState() => _ColoredValueBoxState();
}

class _ColoredValueBoxState extends State<ColoredValueBox> {
  bool _highlighted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
          _highlighted = true;
        }));
  }

  @override
  Widget build(BuildContext context){
    var borderColor = Colors.black;
    var textColor = Colors.black;
    var fontWeight = FontWeight.normal;
    double containerHeight = 40;
    double containerWidth = 40;
    var borderWidth = 1.0;

    if (widget.positionToHighlight != null && widget.positionToHighlight == widget.index) {
      borderColor = Colors.blueGrey;
      textColor = Colors.white;
      borderWidth = 2.0;
      fontWeight = FontWeight.bold;
      containerHeight = 50;
      containerWidth = 50;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      width: _highlighted ? containerWidth : 40,
      height: _highlighted ? containerHeight : 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: _highlighted? borderColor : Colors.black, width: _highlighted? borderWidth : 1.0),
        color: widget.backgroundColor,
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          widget.textToShow,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
  }
}