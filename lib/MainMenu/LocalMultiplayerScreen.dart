
import 'package:flutter/material.dart';

class LocalMultiplayerScreen extends StatelessWidget {
  const LocalMultiplayerScreen({
    super.key,
    required this.changePage,
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
            child: const Text('back')
          ),
        ],
      ),
    );
  }
}