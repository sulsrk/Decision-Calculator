import 'package:flutter/material.dart'; //UI 
import 'sort_algorithms/sort.dart';
import '../reusables/algorithms.dart';
import 'input_box.dart';

class SortPage extends StatefulWidget {

  const SortPage({super.key});

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  // An object storing data about the list and algorithm
  UsersList sortObject = UsersList();
  // List of doable algorithms from Enumerated type
  final List<Algorithms> sortAlgorithms = 
  [Algorithms.bubbleSort,Algorithms.insertionSort,Algorithms.mergeSort,Algorithms.quickSort];
  final int maximum = 25; //constant for maximum number of elements

  Widget getListElement(int i){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListElement(
        value: sortObject.userDefinedList[i],
        delete: () {
          setState(() {
            sortObject.deleteElement(i);  
            //Delete the value at its index
          });
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 88, 166, 1),
      appBar: AppBar( //Topbar
        title: const Text(  //Title
          'Sort Mode',
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 40,
            color: Colors.white,
            fontFamily: 'JustAnotherHand',
            )
          ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(91, 75, 138, 1),
      ),
      body: Column( //Arranging widgets in a column on the screen
        crossAxisAlignment: CrossAxisAlignment.center, //Center all icons horizontally
        children: [
          Padding(  //Column of padding gives each widget its own customisable space
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, //Moving to the left of the screen
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AlgorithmSelection( //Dropdown
                      algorithms: sortAlgorithms,
                      //Function to change the selectedAlgorithm attribute of the sortObject
                      whenSelected: (var algorithm) {
                          sortObject.setAlgorithm(algorithm);
                          //Pushing the algorithm display page when an algorithm is chosen
                          if (sortObject.userDefinedList.isNotEmpty){
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => SortAlgorithmDisplayPage(sortObject: sortObject))
                            );
                          }
                        }
                    ),
                    const Text( //Disclaimer text
                      "Disclaimer: Merge Sort will truncate the list to 12 elements!",
                      style: TextStyle(  
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4
                      ),
                    )
                  ]
                )
              ]
            ),
          ),
          Padding(  //Box for entering elements
            padding: const EdgeInsets.all(70.0),
            child: InputBox(
              whenEntered: (value) {
                //Only add if the elements present are less than the max
                if (sortObject.getUserDefinedList().length < maximum){
                  setState(() {sortObject.addElement(value);});
                }
              },
              whenClearListPressed: () {
                setState(() {sortObject.clearList();});
              },
              counter: ElementCounter(
                total: maximum, //Total num of elements allowed
                count: sortObject.getUserDefinedList().length //Length of list
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(  //Row for elements
              alignment: WrapAlignment.center,
              runSpacing: 10.0, //Spacing between rows
              //For every item in the list, return a listElement widget with that value
              children: List<Widget>.generate(sortObject.userDefinedList.length,
               (index) => getListElement(index), growable: false)
            ),
          )
        ]
      ) 
    );
  }
}

class SortAlgorithmDisplayPage extends StatefulWidget {
  final UsersList sortObject;  //Passed in sortObject
  const SortAlgorithmDisplayPage({super.key, required this.sortObject});

  @override
  State<SortAlgorithmDisplayPage> createState() => _SortAlgorithmDisplayPageState();
}

class _SortAlgorithmDisplayPageState extends State<SortAlgorithmDisplayPage> {
  late GenericSort sort;
  bool ignore = false;  //Value for whether it should accept clicks

  void flipIgnore(){
    setState((){
      ignore = !ignore;
      //Swap the boolean value
    });
  }

  @override
  void initState() {
    super.initState();
    //Storing some sort
    sort = widget.sortObject.getSelectedAlgorithm()!.createSort(widget.sortObject.getUserDefinedList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 88, 166, 1),
      appBar: AppBar( //Topbar
        title: Text(  //Title displaying whichever algorithm is being performed
          widget.sortObject.getSelectedAlgorithm()!.name,
          style: const TextStyle(
            letterSpacing: 2,
            fontSize: 40,
            color: Colors.white,
            fontFamily: 'JustAnotherHand',
            )
          ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(91, 75, 138, 1),
      ),
      body: Center( //Centering
        child: Column( //Column to display all the passes 
          children: [
            Padding(  //Giving the row buttons space
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: 250, //Limiting row size
                child: Row(  //Row for buttons to play through steps
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Even spacing
                  children: [
                    StepButton(
                      tooltip: "Previous pass",
                      icon: Icons.fast_rewind,
                      onTapped: () {
                        if(sort.stepIndex > 0){
                          sort.previousPass();
                        }
                      },
                    ),  //Go to beginning of steps
                    StepButton(
                      tooltip: "Previous step",
                      icon: Icons.fast_rewind_outlined,
                      onTapped: () {
                        if (sort.stepIndex > 0){
                          sort.doStepReverse();
                        }
                      },
                    ), //Previous step
                    StepButton(
                      tooltip: "Next step",
                      icon: Icons.fast_forward_outlined,
                      onTapped:() async {
                        if (sort.stepIndex < sort.stepList.length){
                          sort.doStep();
                        }
                      }
                    ),  //Next step
                    StepButton(
                      tooltip: "Next pass",
                      icon: Icons.fast_forward,
                      onTapped: () {
                        if (sort.stepIndex < sort.stepList.length){
                          sort.nextPass();
                        }
                      },
                    )  //Go to final step
                  ],
                ),
              ),
            ),
            Padding(  //Text explaining the step
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: sort.stepText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: sort.getLayout()
            )
          ],
        ),
      )
    );
  }
}