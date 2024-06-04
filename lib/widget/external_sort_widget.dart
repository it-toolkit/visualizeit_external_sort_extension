import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/widget/sort_process_widget.dart';
import 'package:visualizeit_external_sort_extension/widget/unsorted_file_widget.dart';

class ExternalSortWidget extends StatefulWidget {
  final ExternalSortTransition<num>? _transition;
  final List<num> _fileToSort;
  final int _bufferSize;

  const ExternalSortWidget(this._fileToSort, this._bufferSize, this._transition,
      {super.key});

  @override
  State<ExternalSortWidget> createState() {
    return _ExternalSortWidgetState();
  }
}

class _ExternalSortWidgetState extends State<ExternalSortWidget> {
  late Map<num, Color> mapOfColors;

  @override
  void initState() {
    mapOfColors = generateColorMapFromFileToSort(widget._fileToSort);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 8,
          child: SortProcessWidget(widget._transition, widget._bufferSize, mapOfColors),
        ),
        Expanded(
            flex: 2,
            child: UnsortedFileWidget(widget._fileToSort,
                widget._transition?.unsortedFilePointer, mapOfColors)),
      ],
    );
  }

  Map<num, Color> generateColorMapFromFileToSort(List<num> fileToSort) {
    List<int> indices = List.generate(fileToSort.length, (index) => index);
    indices.sort((a, b) => fileToSort[a].compareTo(fileToSort[b]));

    int totalCount = fileToSort.length;
    int maxHue = 345;
    int startHue = -11;
    Map<num, Color> valueToColorMap = {};

    for (int i = 0; i < totalCount; i++) {
      double hueValue = ((i * maxHue) / (totalCount - 1) + startHue) % 360;
      HSLColor hslColor = HSLColor.fromAHSL(1.0, hueValue, 0.9, 0.57);
      valueToColorMap[fileToSort[indices[i]]] = hslColor.toColor();
    }

    return valueToColorMap;
  }
}
