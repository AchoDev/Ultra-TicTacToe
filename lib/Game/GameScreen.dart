
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/SoundManager.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';
import './SmallTTTField.dart';
import 'dart:math';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../SocketClient.dart' as client;

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.map,
  });

  final String map;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> { 

  void checkWinner() {
    final List<int> currentLayout = List.empty(growable: true);
    for(int i = 0; i < 9; i++) {
      currentLayout.add(fieldKeys[i].currentState!.checkedBy);
    }

    bool checkAll() {
      int counter = 0;
      for(int j = 0; j < 9; j++) {
        if(currentLayout[j] != 0) counter++;
      }

      switch(counter) {
        case 1:
          setPhase(2);
          break;
        case 3:
          setPhase(3);
          break;
        case 5:
          setPhase(4);
          break;
        default:
          break;
      } 

      return counter >= 9;
    }

    checkAll();

    bool _checkSingleMove(List<int> move, int checkEnemy) {
      int counter = 0;
      for(int j = 0; j < 9; j++) {
        if(currentLayout[j] == 1 + checkEnemy && move[j] == 1) counter++;
      } 
      return counter == 3;
    }

    for(List<int> winningMove in winningMoves) {
      if(_checkSingleMove(winningMove, 0)) {
        setState(() {
          winner = 1;
        });
      }

      if(_checkSingleMove(winningMove, 1)) {
        setState(() {
          winner = 2;
        });
      }
    }
  }

  List<List<int>> winningMoves = [
      [ 1, 1, 1,
        0, 0, 0,
        0, 0, 0, ],
      
      [ 0, 0, 0,
        1, 1, 1,
        0, 0, 0, ],
      
      [ 0, 0, 0,
        0, 0, 0,
        1, 1, 1, ],

      [ 1, 0, 0,
        1, 0, 0,
        1, 0, 0, ],
      
      [ 0, 1, 0,
        0, 1, 0,
        0, 1, 0, ],
      
      [ 0, 0, 1,
        0, 0, 1,
        0, 0, 1, ],

      [ 1, 0, 0,
        0, 1, 0,
        0, 0, 1, ],

      [ 0, 0, 1,
        0, 1, 0,
        1, 0, 0, ],
    ];

  bool yourTurn = true;
  int currentField = 9;

  bool movePlayed = false;

  int winner = 0;

  void checkField(int globalPosition, int localPosition) {
    setState(() {
      yourTurn = false;

      setPhase(1);

      movePlayed = true;

      if(fieldKeys[localPosition].currentState!.checked) {
        currentField = 9;
      } else {
        currentField = localPosition;
      }

      client.SocketClient.makeMove(globalPosition, localPosition);
    });


    print('checked position g: $globalPosition l: $localPosition');
  }

  void enemyCheckField(int globalPosition, int localPosition) {
     setState(() {
      yourTurn = true;

      setPhase(1);

      if(fieldKeys[localPosition].currentState!.checked) currentField = 9;
      else currentField = localPosition;
    });

    print('enemy checked pos');
    fieldKeys[globalPosition].currentState?.crossEnemyField(localPosition);
  }

  late List<Container> fields;

  late final List<GlobalObjectKey<SmallTTTFieldState>> fieldKeys;

  int currentPhase = 0;

  void setPhase(int phase) {
    if(currentPhase >= 4) return;
    if(phase <= currentPhase) return;
    
    setState(() => currentPhase = phase);

    print('PHASE $currentPhase');

    final music = SoundManager.findSound('${widget.map}_music');

    if(music == null) return;

    switch(currentPhase) {
      case 1:
        music.play(loop: true);
        music.setVolume(10 / 100);
        break;
      case 2:
        music.setVolume(30 / 100);
        break;
      case 3:
        music.setVolume(60 / 100);
        break;
      case 4:
        music.setVolume(1);
        break;
      default:
        throw RangeError('Phase range is above 4');
    }
  }

  @override
  void initState() {
    super.initState();

    client.SocketClient.listenFor('playermove', (res) {
      
      if(movePlayed) {
        movePlayed = false;
        return;
      }

      yourTurn = true;
      enemyCheckField(res[0], res[1]);
    });

    SoundManager.stopSound('menumusic');

    SoundManager.addSound('${widget.map}_ambience').play(loop: true);
    SoundManager.addSound('${widget.map}_music', volume: 0);

    fieldKeys = List.generate(9, (index) => GlobalObjectKey<SmallTTTFieldState>(index));
  }

  @override
  Widget build(BuildContext context) {

    const Color borderColor = const Color.fromARGB(255, 218, 218, 218);
    const Color notSelectedColor = Color.fromARGB(19, 255, 0, 0);

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width * 2,
        height: MediaQuery.sizeOf(context).height * 2,
        child: Stack(
          children: [
            MapAlike(
              factor: 0.2,
              child: Stack(
                children: [

                  Center(
                    child: Transform.scale(
                      scaleY: 1.3,
                      scaleX: 1.45,
                      child: Image.asset('assets/maps/${widget.map}/${widget.map}_back.png', fit: BoxFit.fill,)
                    ),
                  ),

                  MapAlike(
                    factor: 0.03,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Image(image: AssetImage('assets/maps/${widget.map}/${widget.map}_front.png'), fit: BoxFit.contain,)
                        ),
                  
                        Center(
                          child: IgnorePointer(
                            // ignoring: !yourTurn,
                            ignoring: false,
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tight( Size(
                                MediaQuery.sizeOf(context).height / 1.45,
                                MediaQuery.sizeOf(context).height / 1.45,
                              )),
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: [
                                  for(int i = 0; i < 9; i++)
                                    Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: currentField == 9 || currentField == i ? Colors.transparent : notSelectedColor,
                                        borderRadius: BorderRadius.circular(30),
                                        // boxShadow: [ BoxShadow(
                                        //   color: currentField == 9 ||currentField == i ? Colors.transparent : notSelectedColor,
                                        //   spreadRadius: 10,
                                        //   blurRadius: 10,
                                        // )]
                                      ),
                                      child: SmallTTTField(
                                        key: fieldKeys[i],
                                        checkField: checkField,
                                        checkGlobalWinner: checkWinner,
                                
                                        localPosition: i,
                                        currentlySelected: currentField == 9 || currentField == i,
                                
                                        checkedAsset: 'assets/animations/${widget.map}X',
                                        enemyCheckedAsset: 'assets/animations/${widget.map}O',
                                
                                        winningMoves: winningMoves,
                          
                                        map: widget.map,
                                      )
                                    )
                                ]
                              ),
                            ),
                          ),
                        ),
                            
                      ],
                    ),
                  ),
              
                ],
              )
            ),
          
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,

                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(children: [
                        CircleAvatar(),
                    
                        Text('VS'),
                    
                        CircleAvatar(),
                      ],),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => print('pause menu'), 
                        icon: const Icon(Icons.menu),
                      ),
                    ),

                    Text('PLAYERS TURN'),
                    Text('ENEMY TURN'),


                    Visibility(
                    visible: winner != 0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Color.fromARGB(214, 76, 175, 79),
                      child: Center(
                        child: Text(
                          '${winner == 1 ? 'Player' : 'Enemy'} won the game!',
                          style: const TextStyle(
                            fontSize: 60
                          ),
                        ),
                      ),
                    ),
                  )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}