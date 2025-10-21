part of 'algorithms.dart';

//Stateful widget as its appearance will change during runtime
class AlgorithmSelection extends StatefulWidget {
  final List<Algorithms> algorithms;  //List of algorithm values
  final void Function(dynamic)? whenSelected;  //Function to execute when selected
  //Constructor
  const AlgorithmSelection({super.key, required this.algorithms,this.whenSelected});

  @override
  State<AlgorithmSelection> createState() => AlgorithmSelectionState();
}

class AlgorithmSelectionState extends State<AlgorithmSelection> {
  //Greyed out white color
  final Color white = const Color.fromARGB(255, 235, 235, 235);
  //Style for text concerning drop down menu
  final TextStyle dropDownMenuTextStyle = const TextStyle(  
          fontSize: 15,
          color: Color.fromARGB(255, 235, 235, 235),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4
        );
  //White border
  final BorderSide whiteBorder = const BorderSide(
    color: Colors.white,
    width: 1.1
  );

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<Algorithms>(
      trailingIcon: Icon( //Arrow on the side
        Icons.arrow_drop_down_rounded,
        color: white,
      ),
      textStyle: dropDownMenuTextStyle,
      label: const Text("Choose Algorithm"), //Default label
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: dropDownMenuTextStyle,
        fillColor: const Color.fromRGBO(55, 27, 88, 1), //Background color of button
        filled: true,
        enabledBorder: OutlineInputBorder(  //Border when not selected
          borderSide: whiteBorder,
          borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        focusedBorder: OutlineInputBorder(  //Border when selected
          borderSide: whiteBorder,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(5),
            right: Radius.circular(10)
          )
        ),
      ),
      menuStyle: MenuStyle(
        //Color of menu
        backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(55, 27, 88, 1)),
        side: MaterialStatePropertyAll<BorderSide>(whiteBorder)
      ),
      //Map through the list of Enums and return a DropDownMenuEntry widget with the correct label and value  
      dropdownMenuEntries: (widget.algorithms).map<DropdownMenuEntry<Algorithms>>((Algorithms algorithm){
        return DropdownMenuEntry<Algorithms>(
          value: algorithm, //Store algorithm with selection
          label: algorithm.name,  //Display name of algorithm
          style: MenuItemButton.styleFrom(
            foregroundColor: white
          )
        );
      }).toList(), //Convert Map to List
      //Execute the passed in function when some value is selected
      onSelected: (value) { //value is the value of the dropdown entry
        widget.whenSelected!(value);  //Specifying non null
      }
    );
  }
}