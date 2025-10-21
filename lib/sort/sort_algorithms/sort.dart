library sort_algorithms;
import 'package:flutter/material.dart';
import '../../reusables/algorithms.dart';
part 'bubble_sort.dart';
part 'insertion_sort.dart';
part 'quick_sort.dart';
part 'merge_sort.dart';

const Color defaultDisplayColor = Color.fromRGBO(55, 27, 88, 0.8);
const Color selectedDisplayColor = Color.fromRGBO(22, 210, 142, 1);
const Color finalDisplayColor = Colors.grey;
const Color sortedDisplayColor = Color.fromARGB(255, 255, 191, 0);
const Color pointerDisplayColor = Colors.redAccent;

class UsersList{
  final List<double> userDefinedList = []; //List for values
  Algorithms? _selectedAlgorithm; //Keep track of algorithm
   
  List<double> getUserDefinedList(){
    return userDefinedList; //List getter
  }

  Algorithms? getSelectedAlgorithm(){
    return _selectedAlgorithm;
  }

  void setAlgorithm(Algorithms algorithm){
    _selectedAlgorithm = algorithm;  //Choosing algorithm
  }

  void clearList(){
    userDefinedList.clear();
  }

  void addElement(double value){
    userDefinedList.add(value);  //Appending some value
  }

  void deleteElement(int index){
    userDefinedList.removeAt(index);  //Removing some value
  }
}

class GenericSort{
  late List<double> userDefinedList;
  late List<DisplayListElement> displayList; //List of DisplayElements
  List<SortSteps> stepList = [];  //List of steps
  int currentListIndex = 0; //Current position of pointer of list
  int stepIndex = 0;  //Current position of pointer of step list
  StepText stepText = StepText();  //Text widget showing step

  //When first initialised, go through every element in the sortList and convert it to
  //a DisplayListElement list that can be modified
  GenericSort(List<double> list){
    userDefinedList = List.from(list, growable: false);
    displayList = userDefinedList.map(
        (double val) => DisplayListElement(value: val
      )
    ).toList();
    displayList = List.from(displayList, growable: false);
  }

  Widget getLayout(){
    return Wrap( //Displaying animated version of list
      alignment: WrapAlignment.center,  //Centering
      runSpacing: 10.0, //Spacing between rows
      children: displayList, //List of widgets
    );
  }

  void setStepText(String step){
    stepText.step.value = step;
  }

  void swapElements(int index1, int index2){  //Animating swap
    //Swap the values of the notifiers of the elements
    double temp = displayList[index1].displayVal.value;
    displayList[index1].displayVal.value = displayList[index2].displayVal.value;
    displayList[index2].displayVal.value = temp;
  }

  void changeColorOfElement(int index, Color color) async {
    displayList[index].color.value = color;
  }

  void compareElements(int fIndex, int sIndex) {
    setStepText('''Compare ${displayList[fIndex].displayVal.value} and ${displayList[sIndex].displayVal.value}''');
    
    changeColorOfElement(fIndex, selectedDisplayColor); //Change color to
    changeColorOfElement(sIndex, selectedDisplayColor); //highlight elements
  }

  //To be overidden 
  void doStep(){} 
  void doStepReverse(){} 
  void nextPass(){} 
  void previousPass(){}
}

