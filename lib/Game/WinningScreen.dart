
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/SoundManager.dart';
import 'package:ultra_tictactoe/shared/BeatAnimation.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';

class WinningScreen extends StatelessWidget {
  WinningScreen({
    super.key,
    required this.winner,
    required this.winnerPicture,
    required this.loser,
    required this.loserPicture,

  }) {
    SoundManager.stopAllSounds();
    SoundManager.addSound('winnersmusic').play(loop: true);
  }

  final String winner;
  final String loser;

  final int winnerPicture;
  final int loserPicture;

  final List<String> captions = [
    'he is the ultimate winner',
    'he is FAR superior than his enemy',
    'he is one of the players ever',
    'his GPA is not 2.7',
    'he DESTROYED his enemy',
    'his preferred is anywhere between 0-100',
    'he has 400 hours in Among us',
    'he watched 0 episodes of One Piece',
    'his favorite Sauce is the white one',
    'he never player League of Legends',
    'he has a Minecraft Username with 3 characters',
    'he was lucky',
    'he is probably gay',
    'he forgot to shower yesterday',
    'he cheated',
    'he uses Twitter on a daily basis',
    'he has 3.000.000 Reddit Karma'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapAlike(
        factor: 0.2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(200),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(76, 0, 0, 0),
                blurRadius: 20,
                spreadRadius: 10,
              )
            ]
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      '$winner WON THE GAME!',
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.red,
                      ),
                    ),
      
                    Text(
                      '$winner WON THE GAME!',
                      style: TextStyle(
                        fontSize: 50,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                Text('He won because ${captions[Random().nextInt(captions.length - 1)]}'),
          
                Padding(
                  padding: const EdgeInsets.all(100),
                  child: BeatAnimation(
                    bpm: 150,
                    scaleAmount: 1.7,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              foregroundImage: AssetImage('assets/userpictures/$winnerPicture.jpeg'),
                            ),
      
                            Transform.translate(
                              offset: const Offset(25, -30),
                              child: Transform.rotate(
                                angle: 30 * (pi / 180),
                                child: Image.asset(
                                  'assets/images/crown.png',
                                  scale: 2.5,
                                )
                              ),
                            ),
                          ],
                        ),
                        Text(winner),
                      ],
                    ),
                  ),
                ),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
      
                    CircleAvatar(
                      radius: 40,
                      foregroundImage: AssetImage('assets/userpictures/$loserPicture.jpeg'),
                    ),
      
                    const Text(" <--- loser (We don't talk about him)"),
                  ],
                ),
      
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        SoundManager.stopAllSounds();
                        SoundManager.playSound('menumusic');
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back to lobby')
                    ),
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}