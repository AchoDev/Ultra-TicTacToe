
import 'package:flutter/material.dart';
import 'SmallTTTField.dart';
import 'dart:math';

import 'package:socket_io_client/socket_io_client.dart' as io;

import 'SocketClient.dart' as client;

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
  });


  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> { 

  void checkWinner() {
    final List<int> currentLayout = List.empty(growable: true);
    for(int i = 0; i < 9; i++) {
      currentLayout.add(fieldKeys[i].currentState!.checkedBy);
    }

    print(currentLayout);

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

      movePlayed = true;

      if(fieldKeys[localPosition].currentState!.checked) currentField = 9;
      else currentField = localPosition;

      client.SocketClient.makeMove(globalPosition, localPosition);
    });


    print('checked position g: $globalPosition l: $localPosition');
  }

  void enemyCheckField(int globalPosition, int localPosition) {
     setState(() {
      yourTurn = true;

      if(fieldKeys[localPosition].currentState!.checked) currentField = 9;
      else currentField = localPosition;
    });

    print('enemy checked pos');
    fieldKeys[globalPosition].currentState?.crossEnemyField(localPosition);
  }

  late List<Container> fields;

  late final List<GlobalObjectKey<SmallTTTFieldState>> fieldKeys;

  @override
  void initState() {
    super.initState();

    client.SocketClient.listenFor('playermove', (res) {
      print(yourTurn);
      
      if(movePlayed) {
        movePlayed = false;
        return;
      }

      yourTurn = true;
      enemyCheckField(res[0], res[1]);

    });

    fieldKeys = List.generate(9, (index) => GlobalObjectKey<SmallTTTFieldState>(index));
  }

  @override
  Widget build(BuildContext context) {

    Color borderColor = const Color.fromARGB(255, 218, 218, 218);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => enemyCheckField(currentField != 9 ? currentField : Random().nextInt(8), Random().nextInt(8)),
                      child: Text('enemy checks random')
                    ),
                    ElevatedButton(
                      onPressed: () => enemyCheckField(1, 6),
                      child: Text('enemy checks 1, 6')
                    ),
                    ElevatedButton(
                      onPressed: () => enemyCheckField(1, 4),
                      child: Text('enemy checks 1, 4')
                    ),
                    ElevatedButton(
                      onPressed: () => enemyCheckField(1, 2),
                      child: Text('enemy checks 1, 2')
                    ),
                  ],
                ),

                Text('ULTRA TIC TAC TOE'),
                Text('[[penis]] vs [[ENEMY USERNAME]]'),
                IgnorePointer(
                  ignoring: !yourTurn,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(700, 700)),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: [
                        for(int i = 0; i < 9; i++)
                          Container(
                            decoration: BoxDecoration(
                              color: currentField == 9 || currentField == i ? Colors.red : Colors.grey,
                              border: Border(
                                right: i == 2 || i == 5 || i == 8 ? BorderSide.none : BorderSide(width: 10, color: borderColor),
                                top: i == 0 || i == 1 || i == 2 ? BorderSide.none : BorderSide(width: 10, color: borderColor)
                              )
                            ),
                            child: SmallTTTField(
                              key: fieldKeys[i],
                              checkField: checkField,
                              checkGlobalWinner: checkWinner,

                              localPosition: i,
                              currentlySelected: currentField == 9 || currentField == i,

                              checkedWidget: const Icon(Icons.close_rounded, size: 200,),
                              enemyCheckedWidget: const Icon(Icons.circle_outlined, size: 200,),

                              winningMoves: winningMoves,
                            )
                          )
                      ]
                    ),
                  ),
                ),
              ],
            ),
          
            Visibility(
              visible: winner != 0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromARGB(214, 76, 175, 79),
                child: Center(
                  child: Text(
                    '${winner == 1 ? 'Player' : 'Enemy'} won the game!',
                    style: TextStyle(
                      fontSize: 60
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}