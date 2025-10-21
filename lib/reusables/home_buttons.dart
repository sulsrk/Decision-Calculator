import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String imageNroute; //Holds the image path and route of page (same name)
  final String display; //Holds the display name of the button
  //Constructor setting values
  const CircularButton({super.key, required this.imageNroute, required this.display});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //When pressed, push correct page on navigator stack
        Navigator.pushNamed(context, '/$imageNroute');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(120, 88, 166, 1),
        //Color when hovered over
        foregroundColor: Colors.white,
        //Making it circular and giving it a border
        shape: const CircleBorder(
          side: BorderSide(color: Color.fromRGBO(0, 255, 194, 1))
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, //Limiting column size to not take page
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2, //Giving it a proportion of 2/3 of the button
            child: Padding( //Fit inside circle
              padding: const EdgeInsets.all(20),
              //Loading up correct image from assets
              child: Image(image: AssetImage('assets/$imageNroute.png'))
              )
          ),
          Expanded(
            flex: 1, //Giving it a proportion of 1/3 of the button
            //Displaying text
            child: Text(
              display,
              style: const TextStyle(
                letterSpacing: 1,
                fontFamily: 'JustAnotherHand',
                fontSize: 25,
                color:Colors.white,
                overflow: TextOverflow.ellipsis
                )
              )
          )
        ]
      )
    );
  }
}