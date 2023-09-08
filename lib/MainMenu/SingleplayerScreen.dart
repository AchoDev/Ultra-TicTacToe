
import 'package:flutter/material.dart';

class SingleplayerScreen extends StatelessWidget {
  const SingleplayerScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
     return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 1),
            child: Text('back')
          ),
        ],
      ),
    );
  }
}
