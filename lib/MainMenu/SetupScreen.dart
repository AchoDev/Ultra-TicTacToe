import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';

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
    return MapAlike(
      factor: 0.2,
      child: SizedBox(
    
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'How do you set up a Server?',
              style: const TextStyle(
                fontSize: 30
              ),
            ),

            const SizedBox(height: 20,),
    
            const SizedBox(
              width: 1000,
              child: Text('''
              This Game works by using the Hosts Computer as the server. This means this Game can be only played via LAN. To get around that, install RadminVPN and connect to your friend. After that you can create a Lobby. Your friend then has to join by using your IP-Adress. Note that using tools like RadminVPN will reveal your public IP-Adress to the other person.''',
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20,),
    
            PagejumpButton(
              changePage: changePage, 
              pageX: 1, 
              pageY: yPosition, 
              text: 'Back'
            ),
          ],
        ),
      ),
    );
  }
}