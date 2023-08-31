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



  bool yourTurn = true;
  int currentField = 2;

  void checkField(int globalPosition, int localPosition) {
    setState(() => yourTurn = false);

    print('checked position g: $globalPosition l: $localPosition');
  }

  void enemyCheckField(int globalPosition, int localPosition) {
    setState(() => yourTurn = true);
    print('enemy checked pos');
    fieldKeys[globalPosition].currentState?.crossEnemyField(localPosition);
  }

  late List<Container> fields;

  final List<GlobalObjectKey<_SmallTTTFieldState>> fieldKeys = List.generate(9, (index) => GlobalObjectKey<_SmallTTTFieldState>(index));

  @override
  void initState() {
    super.initState();

    Color borderColor = const Color.fromARGB(255, 218, 218, 218);

    fields = [
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
            localPosition: i,
            currentlySelected: currentField == 9 || currentField == i,
          )
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () => enemyCheckField(2, 4), 
              child: Text('enemy checks 2, 4')
            ),

            Text('ULTRA TIC TAC TOE'),
            Text('[[USERNAME]] vs [[ENEMY USERNAME]]'),
            IgnorePointer(
              ignoring: !yourTurn,
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(const Size(700, 700)),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: fields
                ),
              ),
            ),
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
    required this.localPosition,
    required this.currentlySelected,
  });

  final int localPosition;
  final Function checkField;
  final bool currentlySelected;

  @override
  State<SmallTTTField> createState() => _SmallTTTFieldState();
}

class _SmallTTTFieldState extends State<SmallTTTField> {

  void crossEnemyField(position) {
    buttonKeys[position].currentState?.checkEnemyMark();
  }

  late List<SmallTTTFieldButton> buttons;
  late List<GlobalObjectKey<_SmallTTTFieldButtonState>> buttonKeys = List.generate(9, (index) => GlobalObjectKey<_SmallTTTFieldButtonState>(index + 20));

  @override
  void initState() {
    super.initState();
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
        )
    ];
  }

  @override
  Widget build(BuildContext context) {

    double borderWidth = 4;

    return IgnorePointer(
      ignoring: !widget.currentlySelected,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GridView.count(
            crossAxisCount: 3,
            children: buttons
          ),
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
  });

  final Widget selectedChild;
  final Widget enemySelectedChild;
  final Function checkPosition;
  final int localPosition;

  @override
  State<SmallTTTFieldButton> createState() => _SmallTTTFieldButtonState();
}

class _SmallTTTFieldButtonState extends State<SmallTTTFieldButton> {

  bool selected = false;

  // 1 -> player 2 -> enemy
  int selectedBy = 0;

  void checkEnemyMark() {
    print('selected saaaaaa');
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
