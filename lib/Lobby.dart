
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
      
      body: SizedBox(

        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,

        child: Column(
          children: [
            Row(
              children: [
                _Player(username: 'generic username'),
                _Player(username: 'beautiful name :)')
              ],
            ),
          
            ElevatedButton(
              onPressed: () {
                SocketClient.startGame();
              }, 
              child: Text('START GAME (IF YOURE HOST)')
            )
          ],
        ),
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    super.key,
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 700,
        color: Colors.green.withOpacity(.7),
      
        child: Center(
          child: Text(username),
        ),
      )
    );
  }
}