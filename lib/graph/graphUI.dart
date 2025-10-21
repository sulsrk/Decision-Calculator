import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Graph Theory',
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 40,
            color: Colors.white,
            fontFamily: 'JustAnotherHand',
            )
          ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(91, 75, 138, 100),
      ),
      backgroundColor: const Color.fromRGBO(120, 88, 166, 100),
    );
  }
}