part of '../reusables/algorithms.dart';

Duration colorChangeTime = const Duration(milliseconds: 450);
Duration swapTime = const Duration(seconds: 1);
Duration textDisplayTime = const Duration(milliseconds: 800);

//Pattern for a series of trailing 0s at the end of a number
RegExp trailingZeros = RegExp(r'([.]*0)(?!.*\d)');

class ListElement extends StatelessWidget {
  final double value; //Value of the element to be displayed
  final void Function()? delete; //Function to remove element
  //Constructor assigning value
  const ListElement({super.key, required this.value, this.delete});

  @override
  Widget build(BuildContext context) {
    return Container( //Box for element
      padding: const EdgeInsets.fromLTRB(18, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(55, 27, 88, 0.8), //Color of element
        border: Border.all(width: 1.5), //Giving element border
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(   //Text displaying element
            value.toString().replaceAll(trailingZeros, ""),
            //Removing trailing 0s and displaying value
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "JustAnotherHand",
              fontSize: 30,
              letterSpacing: 1.7
            )
          ),
          IconButton(   //Button for deleting element
            splashRadius: 15, //Splash radius when hovered over
            splashColor: Colors.cyan, //Color when pressed
            color: Colors.white,
            hoverColor: Colors.white,
            onPressed: delete,
            icon: const Icon(Icons.delete_rounded)
          )
        ],
      ),
    );
  }
} 

// ignore: must_be_immutable
class DisplayListElement extends StatelessWidget {
  ValueNotifier<double> displayVal = ValueNotifier<double>(0);  //Value that's displayed
  ValueNotifier<Color> color = ValueNotifier<Color>(  //Color of element
    const Color.fromRGBO(55, 27, 88, 0.8)
    );
  DisplayListElement({super.key, required value}){
    displayVal.value = value;
  }

  Widget buildElement(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal:10),
      child: AnimatedContainer( //Box for element
        duration: colorChangeTime, //Color transitions should take 450ms
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: color.value, //Color of element from color of object
          border: Border.all(width: 1.5), //Giving element border
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Text(   //Text displaying element
          displayVal.value.toString().replaceAll(trailingZeros, ""), 
          //Value from value of object, removing trailing 0s
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "JustAnotherHand",
            fontSize: 30,
            letterSpacing: 1.7
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(  //Listens for a change in value
      valueListenable: displayVal, 
      builder: (BuildContext context, double newDisplayValue, Widget? child) =>
        AnimatedSwitcher(
          switchInCurve: Curves.easeInOutCubic,  //Curves to make smoother transition
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) => 
            ScaleTransition(scale: animation, child: child,),
          duration: swapTime, //Swap animation should take 1s
          child: ValueListenableBuilder<Color>(
            key: Key("$displayVal $color"), //Make every container unique
            valueListenable: color, //Listens for a change of color value
            builder: (BuildContext context, Color newColorValue, Widget? child) =>
              buildElement()
          ),
        )
    );
  }
} 