import 'package:flutter/material.dart';

mixin ColorsMapMixin{
  
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