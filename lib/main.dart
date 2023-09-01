import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:ultra_tictactoe/SocketClient.dart';

import 'Lobby.dart';

import 'package:vector_math/vector_math_64.dart' as vm;

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

  int currentPage = 1;

  void changePage(int newPage) {
    setState(() => currentPage = newPage);
  }



  @override
  Widget build(BuildContext context) {
    Duration transitionDuration = const Duration(milliseconds: 500);
    Curve transitionCurve = Curves.easeInOutBack;

    // double currentTranslation = MediaQuery.of(context).size.width * currentPage;

    return Scaffold(
      body: AnimatedContainer(
        width: 500,
        duration: transitionDuration,
        curve: transitionCurve,

        // transform: Matrix4.identity()..setTranslation(vm.Vector3(currentTranslation, 0, 0)),

        child: Stack(
          children: [
      
            Flexible(

              // width: MediaQuery.of(context).size.width,
      
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
      
                  Logo(),
            
                  ElevatedButton(
                    onPressed: () => setState(() => currentPage = 2,),
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
      
            JoinServerScreen(changePage: changePage,),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Image(image: AssetImage('images/logo.png'))
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
    required this.changePage
  });

  final Function changePage;

  @override
  Widget build(BuildContext context) {

    String username = Random().nextInt(110000).toString();

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => changePage(2)
      ),
      body: Flexible(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
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
        ),
      ),
    );
  }
}

