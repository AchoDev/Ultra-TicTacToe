

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/SocketClient.dart';
import 'package:ultra_tictactoe/shared/JumpOnHover.dart';
import '../GameScreen.dart';

class _Player {
  final String username;
  final int picture;
  final bool isHost;

  const _Player({required this.username, required this.picture,required this.isHost});
}

class Lobby extends StatefulWidget {
  const Lobby({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  State<Lobby> createState() => LobbyState();
}

class LobbyState extends State<Lobby> {

  _Player? you;
  _Player? enemy;

  bool listening = false;

  @override
  void initState() {
    super.initState();
  }

  void listenForServer() {

    listening = true;

    SocketClient.listenFor('hoststartgame', (p0) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GameScreen())
    ));

    SocketClient.listenFor('gameinformation', (information) {


      print(information['you']);
      print(information['you'].runtimeType);

      Map youData = information['you'];
      Map? enemyData = information['enemy'];

      you = _Player(
        username: youData['username'],
        picture: youData['picture'],
        isHost: youData['isHost'],
      );

      enemy = enemyData == null ? null : _Player(
        username: enemyData['username'], 
        picture: enemyData['picture'],
        isHost: enemyData['isHost'],
      );

    });

    SocketClient.listenFor('userjoinedlobby', (information) {
      if(mounted) {
        setState(() => enemy = _Player(
          username: information['username'],
          picture: information['picture'],
          isHost: information['isHost'],
        ));
      }
    });

    SocketClient.listenFor('playerleave', (playerList) {
      setState(() => enemy = null);
    });
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,

      child: Stack(
        children: [

          Container(
            margin: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  SocketClient.stopConnection();
                  widget.changePage(1, 2);
                }, 
                child: const Text('Leave lobby :(')
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(you != null)
                    _PlayerWidget(username: you!.username, picture: you!.picture, isEnemy: false,),

                  Visibility(
                    visible: enemy != null,
                    child: const Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // if(you != null)
                  //   _PlayerWidget(username: you!.username, picture: you!.picture, isEnemy: true,),

                  if(enemy != null)
                    _PlayerWidget(username: enemy!.username, picture: enemy!.picture, isEnemy: true,),
                ],
              ),

              const Text('Select Map'),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SelectableMap()
                ],
              ),

              const SizedBox(height: 40,),
            
              JumpOnHover(
                child: SizedBox(
                  width: 400,
                  height: 100,
                  child: ElevatedButton(
                    
                    onPressed: you != null && you!.isHost ? () {
                      SocketClient.startGame();
                    } : null,
                
                    child: const Text(
                      'START!',
                      style: TextStyle(
                        fontSize: 30
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectableMap extends StatelessWidget {
  const _SelectableMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 100,
      width: 300,
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    super.key,
    required this.username,
    required this.picture,
    required this.isEnemy,
  });

  final String username;
  final int picture;
  final bool isEnemy;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,

      margin: const EdgeInsets.all(10),
      height: 300,
      color: isEnemy ? 
      Color.fromARGB(255, 255, 128, 119) :
      Color.fromARGB(255, 80, 255, 86),
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleAvatar(
            radius: 100,
            foregroundImage: AssetImage('userpictures/$picture.jpeg'),	
          ),

          Text(
            username,
            style: const TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          

          Text(isEnemy ? 'YOUR ENEMY!' : 'YOU!'),
        ],
      ),
    );
  }
}