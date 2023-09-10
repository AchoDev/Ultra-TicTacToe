
import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return MapAlike(
      factor: 0.2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
    
        child: Column(
          children: [
            const Text('CREDITS'),
            const Text('Game made by AchoDev'),
            const Text('Made in ~1.5 Weeks'),
    
    
            const SizedBox(height: 40,),
    
            const Text('Menu'),
            const Text('Press Play - Panda Beats'),
            const SizedBox(height: 10,),
    
            const Text('Palace'),
            const Text('Antonín Dvořák - Serenade for strings in E major'),
            const SizedBox(height: 10,),
    
            const Text('Classroom'),
            const Text('Battle Arcade - Panda Beats'),
            const SizedBox(height: 10,),
            
            const Text('Night'),
            const Text('What is love 8 bit - sora1233333'),
            const SizedBox(height: 10,),
            
            const Text('Winning'),
            const Text('Pixel Party - Panda Beats'),
            const SizedBox(height: 10,),
    
            const SizedBox(height: 40,),
    
            const Text('Special thanks to:'),
    
            for(String name in ['Evren, Emran, Nick, Hamza, Leo'])
              Text(name),
            const Text('For your voices and Faces'),
    
            const SizedBox(height: 40,),
    
            ElevatedButton(
              onPressed: () => changePage(1, 0), 
              child: const Text('Back')
            ),
          ],
        ),
      ),
    );
  }
}