


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_tictactoe/Game/WinningScreen.dart';
import 'package:ultra_tictactoe/SoundManager.dart';
import 'package:ultra_tictactoe/shared/BeatAnimation.dart';
import 'package:ultra_tictactoe/shared/JumpOnHover.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';
import './SmallTTTField.dart';
import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../SocketClient.dart' as client;

class GameScreen extends StatefulWidget {
  GameScreen({
    super.key,
    required this.gameInformation,
    required this.changePage,
  }) {
    map = gameInformation['map'];
  }

  final Map gameInformation;

  Function(int, int) changePage;

  late final String map;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin{ 

  void leaveGame() {
    SoundManager.releaseSound('${widget.map}_music');
    SoundManager.releaseSound('${widget.map}_ambience');
    SoundManager.playSound('menumusic');
    Navigator.of(context).pop();
    client.SocketClient.stopConnection();
    widget.changePage(1, 0);
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyUpEvent && key == 'Escape') {
      setState(() => pauseMenuOpened = !pauseMenuOpened);
    }
    
    return false;
  }

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

    Map you = widget.gameInformation['you'];
    Map enemy = widget.gameInformation['enemy'];

    for(List<int> winningMove in winningMoves) {
      
      void openWinningPage(Map winner, Map loser) async{
        SoundManager.releaseSound('${widget.map}_music');
        SoundManager.releaseSound('${widget.map}_ambience');

        int random = Random().nextInt(3);

        SoundManager.addSound('win${random + 1}').play();
        // SoundManager.addSound('teleport').play();
        SoundManager.addSound('explosion').play();

        _scrollController.stop();

        await Future.delayed(const Duration(seconds: 3));
        
        SoundManager.findSound('win${random + 1}')!.release();
        // SoundManager.findSound('teleport')!.release();
        SoundManager.findSound('explosion')!.release();

        Navigator.of(context).pop();
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => WinningScreen(
              winner: winner['username'],
              winnerPicture: winner['picture'],
              loser: loser['username'],
              loserPicture: loser['picture'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          )
        );
      }

      if(_checkSingleMove(winningMove, 0)) {
        openWinningPage(you, enemy);
      }

      if(_checkSingleMove(winningMove, 1)) {
        openWinningPage(enemy, you);
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

  late bool yourTurn;
  int currentField = 9;

  bool movePlayed = false;

  int winner = 0;

  Map<String, List> bpmMap = {
    'palace': [160, const Color.fromARGB(59, 0, 0, 0), const Color.fromARGB(48, 0, 0, 0)],
    'classroom': [170, const Color.fromARGB(88, 255, 255, 255), const Color.fromARGB(136, 14, 255, 22)],
    'night': [123, const Color.fromARGB(78, 0, 77, 192), const Color.fromARGB(179, 0, 140, 255)],
  };

  void checkField(int globalPosition, int localPosition) {
    if(!mounted) return;
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
    if(!mounted) return;
     setState(() {
      yourTurn = true;

      setPhase(1);

      fieldKeys[globalPosition].currentState?.crossEnemyField(localPosition);
      if(fieldKeys[localPosition].currentState!.checked) currentField = 9;
      else currentField = localPosition;
    });

  }

  late List<Container> fields;

  late final List<GlobalObjectKey<SmallTTTFieldState>> fieldKeys;

  int currentPhase = 0;

  bool pauseMenuOpened = false;

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
        music.setVolumeSmooth(5 / 100);
        break;
      case 2:
        music.setVolumeSmooth(20 / 100);
        break;
      case 3:
        music.setVolumeSmooth(50 / 100);
        break;
      case 4:
        music.setVolumeSmooth(1);
        break;
      default:
        throw RangeError('Phase range is above 4');
    }
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.keyboard.addHandler(_onKey);

    yourTurn = widget.gameInformation['you']['isHost'];

    client.SocketClient.listenFor('playermove', (res) {

      print('MOVE PLAYERD');
      
      if(movePlayed) {
        movePlayed = false;
        return;
      }

      yourTurn = true;
      enemyCheckField(res[0], res[1]);
    });

    client.SocketClient.listenFor('playerleave', (p0) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Enemy left the game'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Oki :3')
            )
          ],
          
        )
      ).then((_) => leaveGame());
    });

    SoundManager.stopSound('menumusic');

    SoundManager.addSound('${widget.map}_ambience', type: SoundType.SoundEffect).play(loop: true);
    SoundManager.addSound('${widget.map}_music', volume: 0);

    fieldKeys = List.generate(9, (index) => GlobalObjectKey<SmallTTTFieldState>(index));
  
    _scrollController = AnimationController(
      duration: const Duration(seconds: 5), 
      vsync: this,
    );
    _scrollController.repeat();
  }

  late final AnimationController _scrollController;
  late Animation _scrollAnimation;

  @override
  Widget build(BuildContext context) {

    _scrollAnimation = Tween<double>(
      begin: -MediaQuery.sizeOf(context).height * 1.3 / 2, 
      end: MediaQuery.sizeOf(context).height * 1.3 / 2).animate(_scrollController);

    const Color borderColor = const Color.fromARGB(255, 218, 218, 218);
    

    Map you = widget.gameInformation['you'];
    Map enemy = widget.gameInformation['enemy'];

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

                  AnimatedBuilder(
                    animation: _scrollAnimation,
                    builder: (context, child) {
                      return Center(
                        child: Transform.translate(
                          offset: Offset(0, widget.map == 'night' ? _scrollAnimation.value : 0),
                          child: Transform.scale(
                            scaleY: 1.3 * (widget.map == 'night' ? 2 : 1),
                            scaleX: 1.45 * (widget.map == 'night' ? 2 : 1),
                            child: Image.asset('assets/maps/${widget.map}/${widget.map}_back.png', fit: BoxFit.fill,)
                          ),
                        ),
                      );
                    }
                  ),

                  MapAlike(
                    factor: 0.06,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Image(image: AssetImage('assets/maps/${widget.map}/${widget.map}_front.png'), fit: BoxFit.contain,)
                        ),
                  
                        Center(
                          child: IgnorePointer(
                            ignoring: !yourTurn,
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
                                      margin: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: currentField == 9 || currentField == i ? Colors.transparent : bpmMap[widget.map]![1],
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

                                        hoveredColor: bpmMap[widget.map]![2],
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
              child: Container(
                padding: const EdgeInsets.all(40),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,

                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: BeatAnimation(
                        bpm: bpmMap[widget.map]![0],
                        scaleAmount: currentPhase != 0 ? 1 + currentPhase * 0.1 : 1,
                        subdivision: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              curve: Curves.bounceOut,
                              duration: const Duration(milliseconds: 500),
                              scale: yourTurn ? 1.3 : 0.75,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    foregroundImage: AssetImage('assets/userpictures/${you['picture']}.jpeg'),
                                  ),
                                  Text(
                                    you['username'],
                                    style: const TextStyle(
                                      color: Colors.blue
                                    ),
                                  )
                                ],
                              ),
                            ),
                        
                             Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60.0),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 40,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6
                                            ..color = const Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        'V',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        'S',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        
                            AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut,
                              scale: !yourTurn ? 1.3 : 0.75,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    foregroundImage: AssetImage('assets/userpictures/${enemy['picture']}.jpeg'),
                                  ),

                                  Text(
                                    enemy['username'],
                                    style: const TextStyle(
                                      color: Colors.red
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                        ],),
                      ),
                    ),
                
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(

                        
                        color: Colors.white,
                        onPressed: () => setState(() => pauseMenuOpened = true), 
                        icon: const Icon(Icons.menu, size: 70,),
                      ),
                    ),
                
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          BeatAnimation(
                            bpm: bpmMap[widget.map]![0],
                            scaleAmount: currentPhase != 0 ? 1 + currentPhase * 0.1 : 1,
                            subdivision: 1 / 2,
                            child: AnimatedContainer(
                              curve: Curves.elasticOut,
                              duration: const Duration(milliseconds: 1300),
                              transform: Matrix4.identity()..setTranslation(vm.Vector3( 
                                0, yourTurn ? 0 : 100, 0)),
                              child: Stack(
                                children: [
                                  Text(
                                    "${you['username']}'s TURN",
                                    style: TextStyle(
                                      fontSize: 40,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6
                                        ..color = const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  Text(
                                    "${you['username']}'s TURN",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.blue
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                
                          BeatAnimation(
                            bpm: bpmMap[widget.map]![0],
                            scaleAmount: currentPhase != 0 ? 1 + currentPhase * 0.1 : 1,
                            subdivision: 1,
                            child: AnimatedContainer(
                              curve: Curves.elasticOut,
                              duration: const Duration(milliseconds: 1300),
                              transform: Matrix4.identity()..setTranslation(vm.Vector3( 
                                0, yourTurn ? 100 : 0, 0)),
                              child: Stack(
                                children: [
                                  Text(
                                    "${enemy['username']}'s TURN",
                                    style: TextStyle(
                                      fontSize: 40,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6
                                        ..color = const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  Text(
                                    "${enemy['username']}'s TURN",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.red
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                    ),


                    // Column(
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () => SoundManager.findSound('${widget.map}_music')!.setVolumeSmooth(0.1), 
                    //       child: Text('smooth vol to 0.1')
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () => SoundManager.findSound('${widget.map}_music')!.setVolumeSmooth(1), 
                    //       child: Text('smooth vol to 1')
                    //     ),
                    //   ],
                    // ),
                
                    // Visibility(
                    //   visible: winner != 0,
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: double.infinity,
                    //     color: Color.fromARGB(214, 76, 175, 79),
                    //     child: Center(
                    //       child: Text(
                    //         '${winner == 1 ? 'Player' : 'Enemy'} won the game!',
                    //         style: const TextStyle(
                    //           fontSize: 60
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Center(
                      child: Visibility(
                        visible: pauseMenuOpened,
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.7,
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.amber,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Pause Menu',
                                style: TextStyle(
                                  fontSize: 40
                                ),
                              ),

                              for(List button in [
                                ['Resume', () => setState(() => pauseMenuOpened = false)],
                                ['Quit', () => leaveGame()],
                              ])
                                JumpOnHover(
                                  child: Container(
                                    width: 400,
                                    height: 100,
                                    margin: const EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      onPressed: button[1], 
                                      child: Text(
                                        button[0],
                                        style: const TextStyle(
                                          fontSize: 20
                                        ),
                                      )
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 20,),

                              const Text('Music Volume'),
                              Slider(
                                value: SoundManager.globalVolume, 
                                onChanged: (value) => setState(() => SoundManager.setGlobalVolume(value))
                              ),

                              const Text('SFX Volume'),
                              Slider(
                                value: SoundManager.globalSFXVolume, 
                                onChanged: (value) => setState(() => SoundManager.setSFXVolume(value))
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
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

