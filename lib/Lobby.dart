
import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/SocketClient.dart';
import 'GameScreen.dart';


class Lobby extends StatefulWidget {
  const Lobby({
    super.key,
  });

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {

  int playercount = 0;

  @override
  void initState() {
    super.initState();
  
    SocketClient.listenFor('hoststartgame', (p0) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameScreen())
    ));

    SocketClient.listenFor('joinlobbyresponse', (p0) {
      print(p0);
      if(mounted) setState(() => playercount += (p0 - 1) as int);
    });

    SocketClient.listenFor('userjoinedlobby', (p1) {
      if(mounted) setState(() => playercount++);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          for(int i = 0; i < playercount; i++)
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.green,
              height: 100,
              width: 200,
              child: Text('PLAYER'),
            ),
        
          ElevatedButton(
            onPressed: () {
              SocketClient.startGame();
            }, 
            child: Text('START GAME (IF YOURE HOST)')
          )
        ],
      ),
    );
  }
}