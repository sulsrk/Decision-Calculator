library algorithms;
import 'package:flutter/material.dart';
import '../sort/sort_algorithms/sort.dart';
part 'dropdown.dart';
part '../sort/element.dart';
part 'step_buttons.dart';

//Enumerated type for which Algorithm is selected
enum Algorithms{
  bubbleSort("Bubble Sort", createBubbleSort),
  insertionSort("Insertion Sort", createInsertionSort),
  quickSort("Quick Sort", createQuickSort),
  mergeSort("Merge Sort", createMergeSort);

  const Algorithms(this.name, this.createSort);
  final String name;  //Display label
  //Function to instantiate a sort
  final GenericSort Function(List<double>) createSort;
}

enum SortSteps{
  partition,
  placePivot,
  addElement,
  compareElements,
  swapElements,
  noSwapElements,
  passComplete,
  sortComplete;
}

GenericSort createBubbleSort(List<double> list){
  return BubbleSort(list);
}

GenericSort createInsertionSort(List<double> list){
  return InsertionSort(list);
}

GenericSort createQuickSort(List<double> list){
  return QuickSort(list);
}

GenericSort createMergeSort(List<double> list){
  return MergeSort(list);
}