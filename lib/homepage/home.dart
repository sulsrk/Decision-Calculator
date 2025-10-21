import 'package:flutter/material.dart';
import '../reusables/home_buttons.dart';

class HomePage extends StatelessWidget { //Home Page widget
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(55, 27, 88, 1),
      body: 
        //Column to arrange different elements
        Column(
          children: [  
            Text(
              "Atlas",
              style: TextStyle(
                fontSize: 300,  //AUTOSIZE CHANGEONDBGBAIUBFSAIBFIJSABFSAHIFASFASK
                fontFamily: 'Monofett',
                color: Colors.white,
                overflow: TextOverflow.ellipsis
              )
            ),
            //Buttons
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Space button evenly
                crossAxisAlignment: CrossAxisAlignment.stretch, //Fill the height of the row
                children: [
                  Flexible(
                    child: CircularButton(imageNroute: 'graphmode', display:'Graph Theory')
                  ),
                  Flexible(
                    child: CircularButton(imageNroute: 'sortmode', display: 'Sorting Mode')
                  ),
                ]
              ),
            ),
            //Image of earth
            Expanded(     //Expanded widget takes up all remaining column space
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, //Moves to the left
                children: [
                  Image(image: AssetImage('assets/earth.png'))
                ]
              )
            )
          ]
        )
      ); 
  }
}