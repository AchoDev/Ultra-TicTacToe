import 'dart:math';

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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Join Server'),
    
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Username'
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'URL'
            ),
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GameScreen())
            ), 
            child: Text('Join')
          )
        ],
      ),
    );
  }
}


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

  int winner = 0;

  void checkField(int globalPosition, int localPosition) {
    setState(() {
      yourTurn = false;

      if(fieldKeys[localPosition].currentState!.checked) currentField = 9;
      else currentField = localPosition;
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

  late final List<GlobalObjectKey<_SmallTTTFieldState>> fieldKeys;

  @override
  void initState() {
    super.initState();

    fieldKeys = List.generate(9, (index) => GlobalObjectKey<_SmallTTTFieldState>(index));
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
                Text('[[USERNAME]] vs [[ENEMY USERNAME]]'),
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

class SmallTTTField extends StatefulWidget {
  const SmallTTTField({
    super.key,
    required this.checkField,
    required this.checkGlobalWinner,

    required this.localPosition,
    required this.currentlySelected,

    required this.checkedWidget,
    required this.enemyCheckedWidget,

    required this.winningMoves,
  });

  final int localPosition;
  final Function checkField;
  final Function checkGlobalWinner;

  final bool currentlySelected;

  final Widget checkedWidget;
  final Widget enemyCheckedWidget;

  final List<List<int>> winningMoves;

  @override
  State<SmallTTTField> createState() => _SmallTTTFieldState();
}

class _SmallTTTFieldState extends State<SmallTTTField> {

  bool checked = false;
  int checkedBy = 0;

  void crossEnemyField(position) {
    buttonKeys[position].currentState?.checkEnemyMark();
    checkWinner();
    widget.checkGlobalWinner();
  }

  void checkWinner() {
    final List<int> currentLayout = List.empty(growable: true);
    for(int i = 0; i < 9; i++) {
      currentLayout.add(buttonKeys[i].currentState!.selectedBy);
    }

    bool _checkSingleMove(List<int> move, int checkEnemy) {
      int counter = 0;
      for(int j = 0; j < 9; j++) {
        if(currentLayout[j] == 1 + checkEnemy && move[j] == 1) counter++;
      } 
      return counter == 3;
    }

    for(List<int> winningMove in widget.winningMoves) {
      if(_checkSingleMove(winningMove, 0)) {
        setState(() {
          checked = true;
          checkedBy = 1;
        });
      }

      if(_checkSingleMove(winningMove, 1)) {
        setState(() {
          checked = true;
          checkedBy = 2;
        });
      }
    }
  }

  late List<SmallTTTFieldButton> buttons;
  late List<GlobalObjectKey<_SmallTTTFieldButtonState>> buttonKeys;

  @override
  void initState() {
    super.initState();

    buttonKeys = List.generate(9, (index) => GlobalObjectKey<_SmallTTTFieldButtonState>(index + (widget.localPosition * 10)));

    buttons = [
      for(int i = 0; i < 9; i++)
        SmallTTTFieldButton(
          key: buttonKeys[i],
          selectedChild: const Icon(Icons.close_rounded, size: 50,),
          enemySelectedChild: const Icon(Icons.circle_outlined, size: 50,),

          localPosition: i,
          checkPosition: (pos) {
            widget.checkField(widget.localPosition, pos);
          },

          checkWinner: () {
            checkWinner(); 
            widget.checkGlobalWinner();
          }
        )
    ];
  }

  @override
  Widget build(BuildContext context) {

    double borderWidth = 4;

    return IgnorePointer(
      ignoring: !widget.currentlySelected || checked,
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: GridView.count(
                crossAxisCount: 3,
                children: buttons
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: checked,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,

                  color: Color.fromARGB(206, 158, 158, 158),
                  child: checkedBy == 1 ? widget.checkedWidget : widget.enemyCheckedWidget,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallTTTFieldButton extends StatefulWidget {
  const SmallTTTFieldButton({
    super.key,
    required this.localPosition,
    required this.checkPosition,
    required this.selectedChild,
    required this.enemySelectedChild,

    required this.checkWinner,
  });


  final Widget selectedChild;
  final Widget enemySelectedChild;
  final Function checkPosition;
  final int localPosition;

  final Function checkWinner;

  @override
  State<SmallTTTFieldButton> createState() => _SmallTTTFieldButtonState();
}

class _SmallTTTFieldButtonState extends State<SmallTTTFieldButton> {

  bool selected = false;

  // 1 -> player 2 -> enemy
  int selectedBy = 0;

  void checkEnemyMark() {
    setState(() {
      selected = true;
      selectedBy = 2;
    });
  }

  void checkMark() {
    if(selected) return;


    setState(() {
      widget.checkPosition(widget.localPosition);
      selected = true;
      selectedBy = 1;
    });

    widget.checkWinner();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(1),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15),
        // border: Border(
        //   right: i == 2 || i == 5 || i == 8 ? BorderSide.none : BorderSide(width: borderWidth),
        //   top: i == 0 || i == 1 || i == 2 ? BorderSide.none : BorderSide(width: borderWidth)
        // )
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => checkMark(),

        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: selected,
              child: selectedBy == 1 ? widget.selectedChild : widget.enemySelectedChild
            ),
          ],
        ),
      ),
    );
  }
}
