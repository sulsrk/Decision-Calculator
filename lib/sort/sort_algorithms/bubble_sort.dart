part of 'sort.dart';

class BubbleSort extends GenericSort{
  late int relativeLength;

  BubbleSort(List<double> list) : super(list){
    int n =  list.length;
    int swapCount;
    if (n > 0){
      do {
        swapCount = 0; //0 swaps at the start of a pass
        //Bubble Sort
        for (int i = 0; i < n - 1; i++){
          stepList.add(SortSteps.compareElements);
          if (userDefinedList[i] > userDefinedList[i + 1]){
            stepList.add(SortSteps.swapElements); //Add swap step
            userDefinedList[i] += userDefinedList[i+1]; 
            userDefinedList[i+1] = userDefinedList[i] - userDefinedList[i+1]; 
            userDefinedList[i] -= userDefinedList[i+1]; //Swapping
            swapCount += 1;
          } else {
            stepList.add(SortSteps.noSwapElements); //Add no swap step
          }
        }
        stepList.add(SortSteps.passComplete); //Add a pass complete step
        n -= 1;
      } while (swapCount > 0 && n > 1);
      stepList.add(SortSteps.sortComplete); //Show when sort is complete
      relativeLength = displayList.length - 1;  //Get last index from length
      stepList = List.from(stepList, growable: false);
    }
  }

  void _bubbleSortComparison(){
    if (currentListIndex > 0){  //Set previous element back to default
      changeColorOfElement(currentListIndex - 1, defaultDisplayColor);
    }
    compareElements(currentListIndex, currentListIndex + 1);
  }

  void _bubbleSortSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is greater than ${displayList[currentListIndex + 1].displayVal.value} so we swap them''');

    swapElements(currentListIndex, currentListIndex + 1); //Swap
    currentListIndex++;
  }

  void _bubbleSortNoSwap(){
    setStepText('''${displayList[currentListIndex].displayVal.value} is not greater than ${displayList[currentListIndex + 1].displayVal.value} so we don't swap them''');
    
    currentListIndex++;
  }

  void _bubbleSortPass(){
    changeColorOfElement(currentListIndex - 1, defaultDisplayColor);  //Set previous to default
    changeColorOfElement(currentListIndex, finalDisplayColor);
    setStepText("${displayList[currentListIndex].displayVal.value} is now in the correct place");
    currentListIndex = 0;  //Going to start of list
    relativeLength--;
  }

  void _bubbleSortComplete(){
    setStepText("The list is sorted, no swaps were needed to be made");
    for (DisplayListElement i in displayList){
      i.color.value = sortedDisplayColor;
    }
  }

  @override
  void doStep() {
    switch(stepList[stepIndex]){
      case SortSteps.compareElements:
        _bubbleSortComparison();
        break;
      case SortSteps.swapElements:
        _bubbleSortSwap();
        break;
      case SortSteps.noSwapElements:
        _bubbleSortNoSwap();
        break;
      case SortSteps.passComplete:
        _bubbleSortPass();
        break;
      default:  //Sort complete
        _bubbleSortComplete();
        break;
    }
    stepIndex++;
  }

  void _bubbleSortReverseComparison(){
    setStepText("Reversing comparison");
    if (currentListIndex == 0){  //Select again previous element
      changeColorOfElement(currentListIndex, defaultDisplayColor);
    } else {  //Select again previous element
      changeColorOfElement(currentListIndex - 1, selectedDisplayColor);
    }
    //Change color back to default from selected
    changeColorOfElement(currentListIndex + 1, defaultDisplayColor);
  }

  void _bubbleSortReverseSwap(){
    setStepText("Reversing swap");
    //Swap step only added on a required swap - no check needed
    swapElements(currentListIndex, currentListIndex - 1);
    currentListIndex--;
  }

  void _bubbleSortReversePass(){
    setStepText("Reversing finalising of last element");
    relativeLength++; currentListIndex = relativeLength;
    //Change back color of relative last elements
    changeColorOfElement(currentListIndex, selectedDisplayColor);
    changeColorOfElement(currentListIndex - 1, selectedDisplayColor);
  }

  void _bubbleSortReverseSortComplete(){
    setStepText("Reversing sort completion");
    for (int i = 0; i <= relativeLength; i++){
      changeColorOfElement(i, defaultDisplayColor);
    } //Change all elements to default color up till index
    for (int i = relativeLength + 1; i < displayList.length; i ++){
      changeColorOfElement(i, finalDisplayColor);
    } //Change the rest of the elements to grey
  }

  @override
  void doStepReverse() {
    stepIndex --; //Decrement
    switch(stepList[stepIndex]){
      case SortSteps.compareElements:
        _bubbleSortReverseComparison();
        break;
      case SortSteps.swapElements:
        _bubbleSortReverseSwap();
        break;
      case SortSteps.noSwapElements:
        setStepText("Reversing no swap");
        currentListIndex--; //Nothing happens in reverse
        break;
      case SortSteps.passComplete:
        _bubbleSortReversePass();
        break;
      default:  //Sort Complete
        _bubbleSortReverseSortComplete();
        break;
    }
  }

  @override
  void nextPass(){
    if (stepIndex == stepList.length - 1){
      _bubbleSortComplete(); stepIndex++;
      return; //If next step is sort complete, perform and break out
    }
    while (stepList[stepIndex] != SortSteps.passComplete){
      doStep(); //Steps are time independant
    }
    _bubbleSortPass(); stepIndex++; //Do the pass complete
    //Show pass number
    setStepText("Pass ${displayList.length - relativeLength - 1}");
  }

  @override
  void previousPass(){
    do{
      doStepReverse();  //Reverse steps until beginning or pass complete
    } while (currentListIndex > 0); //A pass always starts at element 1
    if (stepIndex < stepList.length - 1){
      //Reverse initial comparison if the sort wasn't complete
      stepIndex--; _bubbleSortReverseComparison();
    }
    setStepText("Pass ${displayList.length - relativeLength - 1}");
  }
}