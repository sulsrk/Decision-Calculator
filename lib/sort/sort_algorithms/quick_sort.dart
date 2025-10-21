part of 'sort.dart';

class QuickSort extends GenericSort{
  //List for the sequence of pivots
  List<int> pivotPointers = []; 
  //List for the sequence of new position pointers
  List<int> nextPositionPointers = []; 
  //List for the final position of pivots for reversal
  List<int> finalPivotPointers = [];
  int pivotNum = -1; //Incremented when adding to start at -1 -> 0 
  late int pointer;

  void _performQuickSort(int start, int end){
    if (start < end){ //Termination condition
      double temp;
      stepList.add(SortSteps.addElement); //Create pivot
      pivotPointers.add(end);  //Add initial position of pivot
      nextPositionPointers.add(start);  //Add beginning of sublist
      int pivotPosition = start;
      for (int i = start; i < end; i++){
        stepList.add(SortSteps.compareElements);  //Comparison
        if (userDefinedList[i] < userDefinedList[end]){
          stepList.add(SortSteps.swapElements);
          temp = userDefinedList[i]; userDefinedList[i] = userDefinedList[pivotPosition];
          userDefinedList[pivotPosition] = temp; //Swapping
          pivotPosition += 1;
        } else {
          stepList.add(SortSteps.noSwapElements);
        }
      }
      stepList.add(SortSteps.passComplete); //Pass complete when a pivot is finalised
      temp = userDefinedList[end]; userDefinedList[end] = userDefinedList[pivotPosition];
      userDefinedList[pivotPosition] = temp;  //Finalising temp pivot
      finalPivotPointers.add(pivotPosition); //Add final pivot position
      _performQuickSort(start, pivotPosition - 1);
      _performQuickSort(pivotPosition + 1, end);  //Recursive call
    } 
  }

  QuickSort(List<double> list):super(list){
    _performQuickSort(0, userDefinedList.length - 1);
    stepList.add(SortSteps.sortComplete); //Show completion
  }

  void _quickSortCreatePivot(){
    pivotNum ++;  //Increment to reach nth pivot
    changeColorOfElement(pivotPointers[pivotNum], selectedDisplayColor);  //Highlight pivot
    pointer = nextPositionPointers[pivotNum]; currentListIndex = pointer; //Initialise pointer
    changeColorOfElement(pointer, pointerDisplayColor); //Show as pointer
    setStepText('''Select ${displayList[pivotPointers[pivotNum]].displayVal.value} as a current pivot and ${displayList[pointer].displayVal.value} as its next position pointer''');
  }

  void _quickSortComparison(){
    //Hightlight and compare
    compareElements(currentListIndex, pivotPointers[pivotNum]);
  }

  void _quickSortSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is less than our pivot so we swap it with the pointer and increment its position''');

    swapElements(currentListIndex, pointer);
    changeColorOfElement(pointer, defaultDisplayColor );
    changeColorOfElement(currentListIndex, defaultDisplayColor);  //Set back to default
    pointer ++;  //Increment pointer
    changeColorOfElement(pointer, pointerDisplayColor);
    currentListIndex++; //Increment index
  }

  void _quickSortNoSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is not less than our pivot so we don't swap''');

    if(currentListIndex == pointer){
      //Show as next position pointer
      changeColorOfElement(currentListIndex, pointerDisplayColor);
    } else {
      //Set back to default
      changeColorOfElement(currentListIndex, defaultDisplayColor);
    }
    currentListIndex++; //Increment index
  }

  void _quickSortPass(){
    if (stepList[stepIndex - 1] == SortSteps.swapElements){
      //Unhighlight element before pointer if there was a swap
      changeColorOfElement(pointer - 1, defaultDisplayColor);
    }
    setStepText("Move our pivot to the pointer position and identify it as a past pivot");
    swapElements(pivotPointers[pivotNum], pointer); //Swap pivot & pointer
    changeColorOfElement(pivotPointers[pivotNum], defaultDisplayColor); //Change back color
    changeColorOfElement(pointer, finalDisplayColor); //Highlight as past pivot
  }

  void _quickSortComplete(){
    setStepText('''The list is sorted as all items have been used as pivots, and remaining sublists contain only 1 element''');

    for (DisplayListElement i in displayList){
      i.color.value = sortedDisplayColor;
    } //Change list to sorted color
  }

  @override
  void doStep(){
    switch(stepList[stepIndex]){
      case SortSteps.compareElements:
        _quickSortComparison();
        break;
      case SortSteps.addElement:
        _quickSortCreatePivot();
        break;
      case SortSteps.swapElements:
        _quickSortSwap();
        break;
      case SortSteps.noSwapElements:
        _quickSortNoSwap();
        break;
      case SortSteps.passComplete:
        _quickSortPass();
        break;
      default:  //Sort complete
        _quickSortComplete();
    }
    stepIndex++;
  }

  void _quickSortComparisonReverse(){
    setStepText("Reversing comparison");
    //Change color back, to either pointer or default correspondingly
    if (currentListIndex == pointer){
      changeColorOfElement(currentListIndex, pointerDisplayColor);
    } else {
      changeColorOfElement(currentListIndex, defaultDisplayColor);
    }
  }

  void _quickSortCreatePivoteReverse(){
    setStepText("Reversing pivot & pointer selection");
    //Unhiglight pointer & pivot
    changeColorOfElement(pointer, defaultDisplayColor);
    changeColorOfElement(pivotPointers[pivotNum], defaultDisplayColor);
    pivotNum--;
    if (pivotNum >= 0){ //Validation
      pointer = finalPivotPointers[pivotNum]; //Move back to previous pointer
      currentListIndex = pivotPointers[pivotNum]; //Move back index to pivot
    }
  }

  void _quickSortSwapReverse(){
    setStepText("Reversing swap with pointer");
    changeColorOfElement(pointer, 
    (pointer == pivotPointers[pivotNum]) ? 
    selectedDisplayColor:defaultDisplayColor);
    //^ Show as pivot if pointer is the same, otherwise set to default color
    currentListIndex--; pointer--;  //Moving pointer back by one
    changeColorOfElement(pointer, pointerDisplayColor);
    changeColorOfElement(currentListIndex, selectedDisplayColor);
    swapElements(currentListIndex, pointer);  //Swap back
  }

  void _quickSortNoSwapReverse(){
    setStepText("Reversing no swap");
    currentListIndex--; //Move back and rehighlight
    changeColorOfElement(currentListIndex, selectedDisplayColor);
  }

  void _quickSortPassReverse(){
    setStepText("Reversing finalising of pivot");
    //Changing back pivot & pointer
    changeColorOfElement(currentListIndex, selectedDisplayColor);
    changeColorOfElement(pointer, pointerDisplayColor);
    swapElements(currentListIndex, pointer);
  }

  void _quickSortCompleteReverse(){
    setStepText("Reversing sort completion");
    for (int i = 0; i < displayList.length; i++){
      //If it was a pivot, change to grey otherwise default
      if (finalPivotPointers.contains(i)){
        changeColorOfElement(i, finalDisplayColor);
      } else {
        changeColorOfElement(i, defaultDisplayColor);
      }
    }
  }

  @override
  void doStepReverse(){
    stepIndex--;
    switch(stepList[stepIndex]){
      case SortSteps.compareElements:
        _quickSortComparisonReverse();
        break;
      case SortSteps.addElement:
        _quickSortCreatePivoteReverse();
        break;
      case SortSteps.swapElements:
        _quickSortSwapReverse();
        break;
      case SortSteps.noSwapElements:
        _quickSortNoSwapReverse();
        break;
      case SortSteps.passComplete:
        _quickSortPassReverse();
        break;
      default:  //Sort complete
        _quickSortCompleteReverse();
    }
  }

  @override
  void nextPass(){
    if (stepIndex == stepList.length - 1){
      _quickSortComplete(); stepIndex++; //Show the sort is done
      return; //Guard clause
    }
    //Each pass lasts until a passComplete step
    while(stepList[stepIndex] != SortSteps.passComplete){
      doStep();
    }
    _quickSortPass(); stepIndex++; //Do pass complete
    setStepText("Pass ${pivotNum + 1}");
    //pivotNum indirectly correlates to the pass number
  }

  @override
  void previousPass(){
    //If at the end of step list, do a sort complete reverse
    //Otherwise reverse steps until proceeding a pass complete
    if (stepIndex == stepList.length){
      stepIndex--; _quickSortCompleteReverse();
    } else {
      do{
        doStepReverse();
      } while (stepList[stepIndex] != SortSteps.addElement);
      //addElement proceeds passComplete except for step 1
    }
    setStepText("Pass ${pivotNum+1}");  //Show pass num
  }
}