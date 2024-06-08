import 'package:flutter/material.dart';
import 'package:visualizeit_external_sort_extension/extension/external_sort_transition.dart';
import 'package:visualizeit_external_sort_extension/widget/colors_map_mixin.dart';
import 'package:visualizeit_external_sort_extension/widget/merge_process_widget.dart';
import 'package:visualizeit_external_sort_extension/widget/sort_process_widget.dart';
import 'package:visualizeit_external_sort_extension/widget/unsorted_file_widget.dart';

class ExternalSortWidget extends StatefulWidget {
  final ExternalSortTransition<num>? _transition;
  final List<num> _fileToSort;
  final int _bufferSize;
  final int _fragmentLimit;

  const ExternalSortWidget(this._fileToSort, this._bufferSize, this._fragmentLimit, this._transition,
      {super.key});

  @override
  State<ExternalSortWidget> createState() {
    return _ExternalSortWidgetState();
  }
}

class _ExternalSortWidgetState extends State<ExternalSortWidget> with ColorsMapMixin{
  late Map<num, Color> mapOfColors;

  @override
  void initState() {
    mapOfColors = generateColorMapFromFileToSort(widget._fileToSort);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget processWidget;
    var transition = widget._transition;
    int? unsortedFilePointer;
    if (transition != null) {
      if(transition is SortTransition<num>){
        unsortedFilePointer = transition.unsortedFilePointer;
        processWidget = SortProcessWidget(transition, widget._bufferSize, mapOfColors);
      } else {
        processWidget = MergeProcessWidget(transition as MergeTransition<num>, widget._fragmentLimit, mapOfColors);
      }
    } else {
      processWidget = SortProcessWidget(null, widget._bufferSize, mapOfColors);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 8,
          child: processWidget,
        ),
        Expanded(
            flex: 2,
            child: UnsortedFileWidget(widget._fileToSort, mapOfColors,
                unsortedFilePointer)),
      ],
    );
  }
}
