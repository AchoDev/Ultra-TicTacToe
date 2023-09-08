import 'package:flutter/material.dart';

import '../shared/PagejumpButton.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    super.key,
    required this.changePage,
    required this.yPosition,
  });

  final int yPosition;
  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('How do you set up a Server?'),

          PagejumpButton(
            changePage: changePage, 
            pageX: 1, 
            pageY: yPosition, 
            text: 'Back'
          ),



          Text("I don't know ")
        ],
      ),
    );
  }
}