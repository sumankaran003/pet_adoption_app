import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../WidgetLibrary/elements.dart';
class ConfettiPage extends StatefulWidget {
  final String name;
  const ConfettiPage({Key? key, required this.name}) : super(key: key);

  @override
  State<ConfettiPage> createState() => _ConfettiPageState();
}

class _ConfettiPageState extends State<ConfettiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ SizedBox(
              width: 210,
              child: Lottie.asset('assets/lottie/congratulation.json')),
            textWidget("You have adopted ${widget.name}", 24.0, Theme.of(context).colorScheme.tertiary,),
          
          ]
        ),
      ),
    );
  }
}
