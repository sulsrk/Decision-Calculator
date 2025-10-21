part of 'algorithms.dart';

class StepButton extends StatelessWidget {
  final String tooltip; //Tooltip describing function of button
  final IconData icon;  //Assign some icon to display
  final void Function()? onTapped;  //Function to move through step list
  const StepButton({super.key, required this.icon, required this.tooltip, this.onTapped});

  Widget buildBackground(IconButton child){
    return Container( //Container for background of IconButton
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(166, 136, 252, 1), //Background color
        border: Border.all( //Border
          color: const Color.fromRGBO(55, 27, 88, 1), //Border color
          width: 4 //Border width
        ),
        borderRadius: const BorderRadius.all(Radius.circular(27))
      ),
      child: child  //Use Icon button inside the container
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBackground(
      IconButton(
        tooltip: tooltip,
        splashColor: Colors.white,
        icon: Icon(
          icon, //Use passed in icon
          color: const Color.fromRGBO(55, 27, 88, 1),
          size: 40,
        ),
        padding: EdgeInsets.zero, //Allowing icon to be centered
        onPressed: onTapped,
      ),
    );
  }
}


// ignore: must_be_immutable
class StepText extends StatelessWidget {
  //String of text regarding step
  ValueNotifier<String> step = ValueNotifier<String>("");
  StepText({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: step, //Listening for a different step value
      builder: (BuildContext context, String value, Widget? child) =>
        Text( 
          step.value, //Displaying step
          style: const TextStyle(
            fontFamily: 'JustAnotherHand',
            color: Colors.white,
            letterSpacing: 1.2,
            fontSize: 34
          ),
        ),
    );
  }
}