import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final Widget? counter; //Store a counter with the correct value
  final void Function(double)? whenEntered; //Function for when a value is entered
  final void Function()? whenClearListPressed; //Function when clear list pressed
  //Constructor
  const InputBox({super.key, this.whenEntered, this.whenClearListPressed, this.counter});

  @override
  Widget build(BuildContext context) {
    return Container(
      //Padding on left-top-right-bottom
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(91, 75, 138, 1),  //Background color
        border: Border.all( //Adding black border
          width: 2.2
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: const [BoxShadow(  //Adding shadow
          color: Color.fromARGB(255, 51, 51, 51),
          blurRadius: 1,
          spreadRadius: 1
        )]
      ),
      child: Column(children: [
        ClearList(  //ClearList button
          whenPressed: whenClearListPressed,
        ),
        const SizedBox(height: 50), //Spacing
        ElementInputBar(  //Passing through the function
          whenEntered: whenEntered,
        ),
        SizedBox( //Limit width of row
          width: 510,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, //Send to the right of box
            children: [
              counter!  //Counter widget passed in
            ],
          ),
        )
      ],)
    );
  }
}

class ElementInputBar extends StatefulWidget {
  //Function for when a value is entered
  final void Function(double)? whenEntered;

  const ElementInputBar({super.key, this.whenEntered});

  @override
  State<ElementInputBar> createState() => _ElementInputBarState();
}

class _ElementInputBarState extends State<ElementInputBar> {
  //Control the text in the text field
  final TextEditingController _fieldText = TextEditingController();
  final FocusNode _focus = FocusNode();
  String hintText = "Enter a number";

  @override
  Widget build(BuildContext context) {
    return SizedBox(  //Limit width of Text Field
      width: 350,
      child: TextField(
        maxLength: 4, //Limiting characters
        controller: _fieldText, //Assigning the controller to the text field
        focusNode: _focus,
        canRequestFocus: true,
        textAlign: TextAlign.center,  //Aligning input to centre
        style: const TextStyle(   //Text Style of input
          color: Colors.white,
          fontSize: 22.5,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: hintText,
          hintStyle: const TextStyle(   //Text Style of hint text
            color: Color.fromRGBO(255,255,255,0.7), //Making hint slightly transparent
          ),
          fillColor: const Color.fromRGBO(55, 27, 88, 1),
          filled: true,           //Setting background color of textbox
          enabledBorder: const OutlineInputBorder(  //Adding normal border
            borderSide: BorderSide(width: 2.2),
            borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          focusedBorder: const OutlineInputBorder(  //Adding border when typing
            borderSide: BorderSide(width: 2.2, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15))
          ),
        ),
        //Execute passed in function when some value is submitted
        onSubmitted: (value) {
          try { //Attempt to convert to double
            widget.whenEntered!(double.parse(value));
            setState(() {hintText = "Enter another number";});
            //Change hint text
          } on FormatException {
            setState(() {hintText = "Invalid Input";});
            //Change hint text to suggest invalid input
          }
          _fieldText.clear();  //Clearing text box
          _focus.requestFocus(); //Keeps textfield focused on
        },
      ),
    );
  }
}

class ClearList extends StatelessWidget {
  //Function to clear the list
  final void Function()? whenPressed;
  //Constructor
  const ClearList({super.key, this.whenPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.red), //Red button
        //Space between text and edge of button
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(18)),
        //Giving the button a rounded border
        side: MaterialStatePropertyAll<BorderSide>(BorderSide(width:1.3)),
        shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))))
      ),
      onPressed: whenPressed, //Function to clear list
      child: const Text(   //Clear List text
        "Clear List",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          letterSpacing: 0.5
        ),
      ),
    );
  }
}

class ElementCounter extends StatelessWidget {
  //Total number of elements allowed
  final int total;
  //Count for the number of elements in list
  final int count;
  const ElementCounter({super.key, required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$count/$total", //Showing "count/total"
      style: const TextStyle(
        color: Colors.white,
        fontFamily: "Kavivanar"
      ),
    );
  }
}