
import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: [

          ElevatedButton(
            onPressed: () => changePage(1, 0), 
            child: const Text('back')
          ),

          const Text('CREDITS'),
          const Text('Game made by AchoDev')
        ],
      ),
    );
  }
}