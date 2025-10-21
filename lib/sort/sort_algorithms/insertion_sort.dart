part of 'sort.dart';

class InsertionSort extends GenericSort{
  int newListPointer = 0; 
  List<int> tempIndex = [];

  InsertionSort(List<double> list):super(list){
    int i;
    //Insertion Sort
    for (int pointer = 0; pointer < list.length; pointer++){
      stepList.add(SortSteps.addElement);
      for (i = pointer; i > 0; i--){
        stepList.add(SortSteps.compareElements);
        if (userDefinedList[i] < userDefinedList[i-1]){
          userDefinedList[i] += userDefinedList[i-1];
          userDefinedList[i-1] = userDefinedList[i] - userDefinedList[i-1]; 
          userDefinedList[i] -= userDefinedList[i-1]; //Swapping
          stepList.add(SortSteps.swapElements);
        } else {
          stepList.add(SortSteps.noSwapElements);
          break; //Break from inner for loop
        }
      }
      //Pass complete step after some item is correctly placed
      stepList.add(SortSteps.passComplete);
      tempIndex.add(i); //Add the index of where it was correctly placed
    }
    stepList.add(SortSteps.sortComplete);
    stepList = List.from(stepList, growable: false);
  }

  void _insertionSortAddElement(){
    currentListIndex = newListPointer;  //Move to next element to be added
    changeColorOfElement(currentListIndex, pointerDisplayColor);  //Change to grey
    setStepText("Add ${displayList[currentListIndex].displayVal.value} to the new list");
    newListPointer++; //Increment new list
  }

  void _insertionSortComparison(){
    //Compare current and previous
    compareElements(currentListIndex, currentListIndex - 1);
  }

  void _insertionSortSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is less than ${displayList[currentListIndex - 1].displayVal.value} so we swap''');

    swapElements(currentListIndex - 1, currentListIndex);
    currentListIndex--;
    changeColorOfElement(currentListIndex + 1, sortedDisplayColor); //Change color
    changeColorOfElement(currentListIndex, pointerDisplayColor); //Change color
  }

  void _insertionSortNoSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is not less than ${displayList[currentListIndex - 1].displayVal.value} so we don't swap''');
    
    changeColorOfElement(currentListIndex - 1, sortedDisplayColor);
    changeColorOfElement(currentListIndex, pointerDisplayColor); //Change back colors
  }

  void _insertionSortPass(){
    changeColorOfElement(currentListIndex, sortedDisplayColor); //Show it's sorted
    setStepText("${displayList[currentListIndex].displayVal.value} is in the correct place in the new list");
  }

  void _insertionSortComplete(){
    setStepText("The list is sorted as all items have been added to the new list");
  }

  @override
  void doStep(){
    switch(stepList[stepIndex]){
      case SortSteps.addElement:
        _insertionSortAddElement();
        break;
      case SortSteps.compareElements:
        _insertionSortComparison();
        break;
      case SortSteps.swapElements:
        _insertionSortSwap();
        break;
      case SortSteps.noSwapElements:
        _insertionSortNoSwap();
        break;
      case SortSteps.passComplete:
        _insertionSortPass();
        break;
      default:  //SortComplete()
        _insertionSortComplete();
        break;
    }
    stepIndex++;  //Increment step
  }

  void _insertionSortAddElementReverse(){
    setStepText("Reversing addition of element to new list");
    newListPointer--; //Decrement size of new list
    changeColorOfElement(currentListIndex, defaultDisplayColor);
    if (newListPointer > 0){
      currentListIndex = tempIndex[newListPointer - 1];
    } //Move back
  }

  void _insertionSortComparisonReverse(){
    setStepText("Reversing comparison");
    //Change back colors
    changeColorOfElement(currentListIndex, pointerDisplayColor);
    changeColorOfElement(currentListIndex - 1, sortedDisplayColor);
  }

  void _insertionSortSwapReverse(){
    setStepText("Reversing swap");
    currentListIndex++;
    _insertionSortNoSwapReverse(); //Change colors to selected
    swapElements(currentListIndex - 1, currentListIndex);
  }

  void _insertionSortNoSwapReverse(){
    setStepText("Reversing no swap");
    changeColorOfElement(currentListIndex - 1, selectedDisplayColor);
    changeColorOfElement(currentListIndex, selectedDisplayColor); //Change back color
  }

  void _insertionSortPassReverse(){
    setStepText("Reversing finalising of element");
    changeColorOfElement(currentListIndex, pointerDisplayColor); //Unsort
  }

  @override
  void doStepReverse(){
    stepIndex--;
    switch(stepList[stepIndex]){
      case SortSteps.compareElements:
        _insertionSortComparisonReverse();
        break;
      case SortSteps.swapElements:
        _insertionSortSwapReverse();
        break; 
      case SortSteps.noSwapElements:
        _insertionSortNoSwapReverse();
        break;
      case SortSteps.addElement:
        _insertionSortAddElementReverse();
        break;
      case SortSteps.passComplete:
        _insertionSortPassReverse();
        break;
      default:  //SortCompleteReverse()
        setStepText("Reversing sort completion");
    }
  }

  @override
  void nextPass(){
    //Each pass lasts until a passComplete step
    while(stepList[stepIndex] != SortSteps.passComplete){
      doStep();
    }
    _insertionSortPass(); stepIndex++; //Do pass complete
    setStepText("Pass $newListPointer");
    if (stepIndex == stepList.length - 1){
      _insertionSortComplete(); stepIndex++; //Show the sort is done
    }
  }

  @override
  void previousPass(){
    do{
      doStepReverse();
    } while (stepList[stepIndex] != SortSteps.addElement);
    //addElement proceeds passComplete except for step 1
    setStepText("Pass $newListPointer");  //Show pass num
  }
}