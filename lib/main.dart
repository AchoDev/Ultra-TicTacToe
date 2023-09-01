import 'dart:math';
import 'package:ultra_tictactoe/SocketClient.dart';

import 'Lobby.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,

        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ultra TicTacToe'),
      
            Text('Made by AchoDev'),
      
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => JoinServerScreen())
              ), 
              child: Text('Join Server')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SetupScreen())
              ), 
              child: Text('How to set up server')
            ),
          ],
        ),
      ),
    );
  }
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          Text('How do you set up a Server?'),
          Text("I don't know ")
        ],
      ),
    );
  }
}


class JoinServerScreen extends StatelessWidget {
  const JoinServerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    String username = Random().nextInt(110000).toString();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Join Server'),
    
          TextField(
            controller: TextEditingController(text: username),
            decoration: InputDecoration(
              hintText: 'Enter Username',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'URL'
            ),
          ),

          ElevatedButton(
            onPressed: () {

              
              SocketClient.joinLocalLobby(username);

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lobby()));
            }, 
            child: Text('Join')
          )
        ],
      ),
    );
  }
}

