import 'package:flutter/material.dart';
import 'homepage/home.dart';
import 'graph/graphUI.dart';
import 'sort/sortUI.dart';

void main() async{  
  runApp(const DecisionCalculator());     //Running Application
}

class DecisionCalculator extends StatelessWidget{
  const DecisionCalculator({super.key});
  //Main class to manage different pages of the app
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Hash table of different pages to build
      routes: {
        '/':(context) => const HomePage(), //default
        '/graphmode':(context) => const GraphPage(),
        '/sortmode':(context) => const SortPage()
      }
    );
  }
}
