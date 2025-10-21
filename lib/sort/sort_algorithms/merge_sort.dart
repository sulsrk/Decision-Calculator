part of 'sort.dart';

class MergeNode{
  List<DisplayListElement> sublist; //Display
  late List<double> initValues;
  MergeNode? parentNode;
  MergeNode? leftNode;
  MergeNode? rightNode;
  bool sorted = false;

   //Assign sublist and parent node
  MergeNode({required this.sublist, this.parentNode}){
    if (sublist.length == 1){
      sorted = true;
      sublist[0].color.value = sortedDisplayColor;
      //Show as sorted if of length 1
    }
    //Store a double list of all the initial values
    initValues = sublist.map(
      (DisplayListElement element) => element.displayVal.value 
    ).toList(growable: false);
  }

  List<DisplayListElement> _cloneList(List<DisplayListElement> list){
    List<DisplayListElement> temp = List<DisplayListElement>.from(list, growable: false);
    //Create array of list items
    for (int i = 0; i < temp.length; i++){
      //Instantiate a new object for every element in the array
      temp[i] = DisplayListElement(value: temp[i].displayVal.value);
    }
    return temp;
  }

  void setLeftNode(List<DisplayListElement> list){
    leftNode = MergeNode(
      //Creating a new version of the list in memory
      sublist: _cloneList(list),
      parentNode: this
    );
  }

  void setRightNode(List<DisplayListElement> list){
    rightNode = MergeNode(
      //Creating a new version of the list in memory
      sublist: _cloneList(list),
      parentNode: this
    );
  }

  void popLeftNode(){
    leftNode = null;
  }
  
  void popRightNode(){
    rightNode = null;
  }

  Widget getWidgetTree(){
    Widget leftColumn; Widget rightColumn;

    if (leftNode == null){
      leftColumn = const SizedBox();
      //Empty expanded box
    } else {
      leftColumn = leftNode!.getWidgetTree();
      //Effectively a depth first traversal down to the left
    }

    if (rightNode == null){
      rightColumn = const SizedBox();
      //Empty expanded box
    } else {
      rightColumn = rightNode!.getWidgetTree();
      //Effectively the depth first traversal going back up & right
    }

    return Expanded(
      //If the flex values are the same, they share the parent row 1:1
      flex: sublist.length,
      //Otherwise, a larger proportion goes to the larger list
      child: Column(
        children: [
          Padding(
            //Give spacing between the rows
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10.0,
              children: sublist
            ),
          ),
          Row(
            //Keep levels of lists from the start
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftColumn,
              rightColumn
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MergeTree extends StatelessWidget {
  MergeNode root;
  late MergeNode pointer;
  //Notifier used for triggering rebuilds
  ValueNotifier<bool> rebuilder = ValueNotifier<bool>(true);

  MergeTree({super.key, required this.root}){
    pointer = root; //Set pointer to root node
  }

  void rebuild(){
    //Flip the bool value triggering a rebuild
    rebuilder.value = !rebuilder.value;
  }

  void traverseLeft(){
    if (pointer.leftNode == null){
      return;
    } //Guard clause
    pointer = pointer.leftNode!;
  }

  void traverseRight(){
    if (pointer.rightNode == null){
      return;
    } //Guard clause
    pointer = pointer.rightNode!;
  }

  void traverseBack(){
    if (pointer == root){
      return;
    } //Guard clase
    pointer = pointer.parentNode!;
  }

  double getValAtIndex(int index){
    return pointer.sublist[index].displayVal.value;
  }

  double getLeftValAtIndex(int index){
    return pointer.leftNode!.sublist[index].displayVal.value;
  }

  double getRightValAtIndex(int index){
    return pointer.rightNode!.sublist[index].displayVal.value;
  }

  void addLevel(){
    //Create 2 nodes by halving the current node's sublist size
    pointer.setLeftNode(pointer.sublist.sublist(0,pointer.sublist.length~/2));
    pointer.setRightNode(pointer.sublist.sublist(pointer.sublist.length~/2));
    rebuild();
  }

  void removeLevel(){
    //Remove the 2 children nodes and move up
    pointer.popLeftNode();
    pointer.popRightNode();
    rebuild();
  }

  void changeColorOfLeftElement(int index, Color color){
    //Change color of some index in the left child
    pointer.leftNode!.sublist[index].color.value = color;
  }

  void changeColorOfRightElement(int index, Color color){
    //Change color of some index in the right child
    pointer.rightNode!.sublist[index].color.value = color;
  }

  void changeColorOfElement (int index, Color color){
    //Change color of some index in the pointer
    pointer.sublist[index].color.value = color;
  }

  void changeColourOfList(Color newColor){
    for (DisplayListElement i in pointer.sublist){
      i.color.value = newColor;
    } //Change the color of all values in pointer sublist
  }

  void popElementLeft(int index, int indexL){
    //Place value of the index in the left sublist at the index in the current
    pointer.sublist[index].displayVal.value = getLeftValAtIndex(indexL);
    changeColorOfElement(index, sortedDisplayColor);
    changeColorOfLeftElement(indexL, finalDisplayColor);
  }

  void popElementRight(int index, int indexR){
    //Place value of the index in the right sublist at the index in the current
    pointer.sublist[index].displayVal.value = getRightValAtIndex(indexR);
    changeColorOfElement(index, sortedDisplayColor);
    changeColorOfRightElement(indexR, finalDisplayColor);
  }

  void reversePopLeft(index){
    //Reset value at index and change the color back
    pointer.sublist[index].displayVal.value = pointer.initValues[index];
    changeColorOfElement(index, pointerDisplayColor); //Remove sorted color
  }

  void reversePopRight(index){
    //Reset value at index and change the color back
    pointer.sublist[index].displayVal.value = pointer.initValues[index];
    changeColorOfElement(index, pointerDisplayColor); //Remove sorted color
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: rebuilder, //Listening for a change in value of rebuilder
      builder: (BuildContext context,bool sudo, Widget? child) =>
        //Calling recursive method to get widget
        Row(children: [root.getWidgetTree()])
    );
  }
}

class MergeSort extends GenericSort{
  late MergeTree mergeTree;
  int currentListIndexR = 0; int currentListIndexL = 0;
  int passCount = 0;
  List<int> pastLIndexes = []; List<int> pastRIndexes = [];

  void _merge(int start,int mid, int end){  //Exclusive of end index
    //Creating the 2 temporary 'stacks'
    List<double> listL = userDefinedList.sublist(start, mid);
    List<double> listR = userDefinedList.sublist(mid,end);
    int indexL=0; int indexR=0; int mainListIndex = start;

    //Repeat until the end of one of the temp arrays is reached
    while (indexL < mid - start && indexR < end - mid){
      stepList.add(SortSteps.compareElements);
      //NOTE: SWAP ELEMENT INDICATES ELEMENT FROM LEFT LIST IS MOVED
      if (listL[indexL] < listR[indexR]){
        stepList.add(SortSteps.swapElements);
        userDefinedList[mainListIndex] = listL[indexL];
        indexL++;
      }
      //NOTE: NO SWAP ELEMENT INDICATES ELEMENT FROM RIGHT IS MOVED
      else {
        stepList.add(SortSteps.noSwapElements);
        userDefinedList[mainListIndex] = listR[indexR];
        indexR++;
      }
      mainListIndex++;
    }

    //Step for copying remaining elements across
    stepList.add(SortSteps.addElement);
    //Store the indexes as of current for reversing
    pastLIndexes.add(indexL);pastRIndexes.add(indexR);
    for (indexL; indexL < mid-start; indexL++){
      userDefinedList[mainListIndex] = listL[indexL];
      mainListIndex++;
    }
    for (indexR; indexR < end - mid; indexR++){
      userDefinedList[mainListIndex] = listR[indexR];
      mainListIndex++;
    }
  }

  void _performMergeSort(int start, int end){ //End exclusive
    if (start < end - 1){ //Termination condition
      int mid = (start+end) ~/ 2; //Finding midpoint
      stepList.add(SortSteps.partition);  //Partition step
      _performMergeSort(start, mid);  //Going down left side
      _performMergeSort(mid, end);  //Going down right side
      stepList.add(SortSteps.passComplete); //Use pass complete for merging
      _merge(start, mid, end);  //Merging lists
    }
  }

  MergeSort(List<double> list):super(list){
    if (userDefinedList.length > 12){
      displayList = displayList.sublist(0,12);
      userDefinedList = userDefinedList.sublist(0,12);
    }
    //Instantiate mergeTree display
    mergeTree = MergeTree(root: MergeNode(sublist: displayList));
    //Getting merge sort steps
    _performMergeSort(0, userDefinedList.length);
    stepList.add(SortSteps.sortComplete);
  }

  @override
  Widget getLayout(){
    return mergeTree;
  }

  void _mergeSortPartition(){
    setStepText("Partition unsorted lists till 2 are sorted (length of 1)");
    //Set previous list back to default
    mergeTree.changeColourOfList(defaultDisplayColor);
    if (mergeTree.pointer.leftNode != null){
      //Traverse right if the left node is sorted, else traverse left
      if(mergeTree.pointer.leftNode!.sorted){
        mergeTree.traverseRight();
      } else {
        mergeTree.traverseLeft();
      }
    }
    mergeTree.addLevel(); //Divide into 2 more levels
    //Highlight current list
    mergeTree.changeColourOfList(pointerDisplayColor); 
  }

  void _mergeSortPass(){
    setStepText("We have 2 sorted sublists so we can begin to merge them");
    passCount++; //Increase pass count
  }

  void _mergeSortComparison(){
    //Comparing using 2 indexes for the 2 child sublists
    setStepText('''Compare ${mergeTree.getLeftValAtIndex(currentListIndexL)} and ${mergeTree.getRightValAtIndex(currentListIndexR)}''');

    //Changing colors to selected in each sublist
    mergeTree.changeColorOfLeftElement(currentListIndexL, selectedDisplayColor);  
    mergeTree.changeColorOfRightElement(currentListIndexR, selectedDisplayColor);
  }

  void _mergeSortLeftSwap(){
    setStepText('''${mergeTree.getLeftValAtIndex(currentListIndexL)} is less than ${mergeTree.getRightValAtIndex(currentListIndexR)} so we add it to the list above''');

    //Pop the element and change colors
    mergeTree.popElementLeft(currentListIndex, currentListIndexL);  
    currentListIndexL++;currentListIndex++;
  }

  void _mergeSortRightSwap(){
    setStepText('''${mergeTree.getLeftValAtIndex(currentListIndexL)} is not less than ${mergeTree.getRightValAtIndex(currentListIndexR)} so we add ${mergeTree.getRightValAtIndex(currentListIndexR)} to the list above''');
     
    //Pop the element and change colors
    mergeTree.popElementRight(currentListIndex, currentListIndexR);
    currentListIndexR++;currentListIndex++;
  }

  void _mergeSortAddElements(){
    //Adding any elements if needed
    for (currentListIndexL; currentListIndexL < mergeTree.pointer.leftNode!.sublist.length; currentListIndexL++){
      mergeTree.popElementLeft(currentListIndex, currentListIndexL);
      currentListIndex++;
    }
    for (currentListIndexR; currentListIndexR < mergeTree.pointer.rightNode!.sublist.length; currentListIndexR++){
      mergeTree.popElementRight(currentListIndex, currentListIndexR);
      currentListIndex++;
    }
    mergeTree.pointer.sorted = true; //Set list as sorted
    //Moving back up
    String back = "We have reached the end of a sublist, so add remaining elements of the other to the list";
    if (mergeTree.pointer != mergeTree.root){
      back += ", and traverse back";  //Show traverse back if we are not at the top
      mergeTree.traverseBack(); //Moving back up
      mergeTree.changeColourOfList(pointerDisplayColor);  //Highlight pointer
    }
    setStepText(back);
    currentListIndexL = 0;currentListIndexR = 0; currentListIndex = 0; //Reset indexes
  }

  void _mergeSortComplete(){
    setStepText("We have merged all partitions so the list is sorted");
  }

  @override
  doStep(){
    switch(stepList[stepIndex]){
      case SortSteps.partition:
        _mergeSortPartition();
        break;
      case SortSteps.passComplete:
        _mergeSortPass();
        break;
      case SortSteps.compareElements:
        _mergeSortComparison();
        break;
      case SortSteps.swapElements:
        _mergeSortLeftSwap();
        break;
      case SortSteps.noSwapElements:
        _mergeSortRightSwap();
        break;
      case SortSteps.addElement:
        _mergeSortAddElements();
        break;
      default:  //Sort complete
        _mergeSortComplete();
    }
    stepIndex++;
  }

  void _mergeSortPartitionReverse(){
    setStepText("Reversing partition");
    mergeTree.changeColourOfList(defaultDisplayColor);  //Reset to default color
    mergeTree.removeLevel(); //Rid of children nodes
    mergeTree.traverseBack(); //Move back up
    mergeTree.changeColourOfList(pointerDisplayColor); //Highlight
  }

  void _mergeSortPassReverse(){
    setStepText("Reversing beginning of merging");
    passCount--;
  }

  void _mergeSortComparisonReverse(){
    setStepText("Reversing comparison");
    //Reverse highlight and show as sorted instead
    if (stepList[stepIndex - 1] != SortSteps.swapElements){
      //If left element wasn't swapped, unhighlight right
      mergeTree.changeColorOfRightElement(currentListIndexR, sortedDisplayColor);
    }
    if (stepList[stepIndex - 1] != SortSteps.noSwapElements){
      //If right element wasn't swapped, unhighlight left
      mergeTree.changeColorOfLeftElement(currentListIndexL, sortedDisplayColor);
    }
  }

  void _mergeSortLeftSwapReverse(){
    setStepText("Reversing swap from left sub list");
    currentListIndexL--;currentListIndex--; //Decrement
    //Reverse the pop and change back to highlight
    mergeTree.reversePopLeft(currentListIndex);
    mergeTree.changeColorOfLeftElement(currentListIndexL, selectedDisplayColor);
  }

  void _mergeSortRightSwapReverse(){
    setStepText("Reversing swap from right sub list");
    currentListIndexR--;currentListIndex--; //Decrement
    //Reverse the pop and change back to highlight
    mergeTree.reversePopRight(currentListIndex);
    mergeTree.changeColorOfRightElement(currentListIndexR, selectedDisplayColor);
  }

  void _mergeSortAddElementsReverse(){
    setStepText("Reversing addition of remaining elements");
    if (!mergeTree.root.sorted){  //If the root is not sorted
      mergeTree.changeColourOfList(defaultDisplayColor);
      if (mergeTree.pointer.rightNode!.sorted){  //If right is sorted
        mergeTree.traverseRight();  //Works 'left to right' so go right
      } else {
        mergeTree.traverseLeft(); //Go left
      }
    }
    //Change back the currentListIndexes
    currentListIndex = mergeTree.pointer.sublist.length;
    currentListIndexL = mergeTree.pointer.leftNode!.sublist.length;
    currentListIndexR = mergeTree.pointer.rightNode!.sublist.length;
    mergeTree.pointer.sorted = false; //Register as unsorted
    //Reverse pop until the pointers are back in original position
    while (currentListIndexL > pastLIndexes[passCount - 1]){ // 0th index -> -1
      //Reverse pop left 
      currentListIndexL--;currentListIndex--;
      mergeTree.reversePopLeft(currentListIndex);
      //Show all as sorted, except the last to be swapped
      if (currentListIndexL == pastLIndexes[passCount - 1]){
        mergeTree.changeColorOfLeftElement(currentListIndexL, selectedDisplayColor);
      } else {
        mergeTree.changeColorOfLeftElement(currentListIndexL, sortedDisplayColor);
      }
    }
    while (currentListIndexR > pastRIndexes[passCount - 1]){
      //Reverse pop right
      currentListIndexR--;currentListIndex--;
      mergeTree.reversePopRight(currentListIndex);
      //Show all as sorted, except the last to be swapped
      if (currentListIndexR == pastRIndexes[passCount - 1]){
        mergeTree.changeColorOfRightElement(currentListIndexR, selectedDisplayColor);
      } else {
        mergeTree.changeColorOfRightElement(currentListIndexR, sortedDisplayColor);
      }
    }
  }

  @override
  doStepReverse(){
    stepIndex--;
    switch(stepList[stepIndex]){
      case SortSteps.partition:
        _mergeSortPartitionReverse();
        break;
      case SortSteps.passComplete:
        _mergeSortPassReverse();
        break;
      case SortSteps.compareElements:
        _mergeSortComparisonReverse();
        break; 
      case SortSteps.swapElements:
        _mergeSortLeftSwapReverse();
        break;
      case SortSteps.noSwapElements:
        _mergeSortRightSwapReverse();
        break;
      case SortSteps.addElement:
        _mergeSortAddElementsReverse();
        break;
      default: //Sort complete
        setStepText("Reversing sort completion");
      //Nothing needs to occur on sort complete
    }
  }

  @override
  nextPass(){
    //Each pass lasts until a passComplete step
    do{
      doStep();
      //Loop until we reach end of step list or pass complete
    } while (stepIndex < stepList.length && stepList[stepIndex] != SortSteps.passComplete);
    if (stepIndex != stepList.length){
      doStep(); //Do pass or sort complete step
      setStepText("Pass $passCount");
    }
  }

  @override
  void previousPass() {
    do{
      doStepReverse();
      //Loop until pass complete or the beginning of step list
    } while(stepIndex > 0 && stepList[stepIndex - 1] != SortSteps.passComplete);
    setStepText(("Pass $passCount")); //Show pass number
  }
}