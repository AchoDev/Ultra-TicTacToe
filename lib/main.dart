



import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:ultra_tictactoe/GameScreen.dart';
import 'package:ultra_tictactoe/SocketClient.dart';


import 'package:google_fonts/google_fonts.dart';

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  int currentPageX = 1;
  int currentPageY = 0;

  void changePage(int pageX, int pageY) {
    setState(() {
      currentPageX = pageX;
      currentPageY = pageY;
    });
  }

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _backgroundTween = Tween<double>(begin: 10 * -250, end: 0);

    _backgroundController.repeat();

    _audioPlayer = AudioPlayer();

<<<<<<< Updated upstream
    _audioPlayer.play(DeviceFileSource('audio/menumusic.mp3'));
=======
    _audioPlayer.onPlayerComplete.listen(
      (event) {
        _audioPlayer.play(DeviceFileSource('assets/audio/menumusic.mp3'));
      }
    );

    _audioPlayer.play(DeviceFileSource('assets/audio/menumusic.mp3'));
>>>>>>> Stashed changes

    
  }

  @override
  void dispose() {
    super.dispose();

    _backgroundController.dispose();
  }

  late AnimationController _backgroundController;
  late Tween<double> _backgroundTween;


  late Animation<double> animation;

  late AudioPlayer _audioPlayer;

  List<IconData> icons = List.generate(500, (index) => IconData(int.parse('0xe${Random().nextInt(9)}b${Random().nextInt(9)}'), fontFamily: 'MaterialIcons'));

  double iconOpc = 1;

  @override
  Widget build(BuildContext context) {

    // double backgroundTileSize = MediaQuery.sizeOf(context).width / 15;
    double backgroundTileSize = 250;

    animation = CurvedAnimation(parent: _backgroundController, curve: Curves.linear);
      // ..addStatusListener((status) {

      //   if(status == AnimationStatus.forward) {
          
      //   }

      // });

    return Scaffold(
      body: Stack(
        children: [

          AnimatedBuilder(

            animation: _backgroundController,
            builder: (context, child) {

              if(_backgroundController.value > 0.9) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setState(() => iconOpc = 0));
              }
              else if(iconOpc != 1) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setState(() => iconOpc = 1));
              }

              return Positioned(
                // duration: const Duration(seconds: 5),

                right: _backgroundTween.evaluate(animation),
                top: _backgroundTween.evaluate(animation),

                // right: 1000,
                // top: 1000,
                
                height: backgroundTileSize * 20,
                width: backgroundTileSize * 20,

                child: GridView.count(

                  physics: const NeverScrollableScrollPhysics(),
                  
                  crossAxisCount: 20,
                
                  children: [
                    for(int i = 0; i < 20; i++)
                      for(int j = 0; j < 20; j++)
                        Container(
                          width: 10,
                          height: 1,
                
                          color: (i % 2 == 0 && j % 2 != 0) || (i % 2 != 0 && j % 2 == 0)? Colors.red[400] : Colors.blue[400],

                          child: AnimatedOpacity(
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 200),
                            opacity: iconOpc,
                            child: Icon(icons[i * j + i], size: 100,)
                          ),
                        )
                  ],
                ),
              );
            }
          ),

          AnimatedPositioned(

            duration: const Duration(milliseconds: 1200),
            curve: Curves.elasticOut,

            width: MediaQuery.of(context).size.width * 3,
            height: MediaQuery.of(context).size.height * 3,
            left: currentPageX * -MediaQuery.of(context).size.width,
            top: currentPageY * -MediaQuery.of(context).size.height,

            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    CreditsScreen(
                      changePage: changePage,
                    ),

                    MainScreen(
                      changePage: changePage,
                      audioPlayer: _audioPlayer,
                    ),
                      
                    SettingsScreen(
                      changePage: changePage,
                    )

                    // JoinServerScreen(changePage: changePage,),
                  ],
                ),

                // JoinServerScreen(changePage: changePage),

                PlayScreen(
                  changePage: changePage,
                ),

<<<<<<< Updated upstream
                JoinServerScreen(
                  changePage: changePage
                ),
=======

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SetupScreen(
                      changePage: changePage,
                      yPosition: 2,
                    ),
                    JoinServerScreen(
                      changePage: changePage,
                      lobbyKey: lobbyKey,
                    ),

                    BlankPage(),

                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SetupScreen(
                      changePage: changePage,
                      yPosition: 3,
                    ),
                    Lobby(
                      key: lobbyKey,
                      changePage: changePage,
                    ),
                    BlankPage(),
                  ],
                ),

>>>>>>> Stashed changes
              ],
            ),
          ),
        ],
      ),
    );
  }
}

<<<<<<< Updated upstream
class PlayScreen extends StatelessWidget {
  const PlayScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 0),
            child: Text('back')
          ),

          FilledButton(
            onPressed: () => print('fjdksafjk'),
            child: Text(
              'Singleplayer',
              style: GoogleFonts.pressStart2p(
                fontSize: 10
              ),
            )
          ),

=======
class BlankPage extends StatelessWidget {
  @override
  Widget build(context) => SizedBox(
    height: MediaQuery.sizeOf(context).height,
    width: MediaQuery.sizeOf(context).width,
  );
}
>>>>>>> Stashed changes

          FilledButton(
            onPressed: () => changePage(1, 2),
            child: Text(
              'Multiplayer',
              style: GoogleFonts.pressStart2p(
                fontSize: 10
              ),
            )
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.changePage,
    required this.audioPlayer
  });
  
  final Function(int, int) changePage;
  final AudioPlayer audioPlayer;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Offset mousePosition = const Offset(1000, 500);

  @override
  Widget build(BuildContext context) {
    return MapAlike(
        factor: 0.2,
        child: Container(
      
          constraints: BoxConstraints.tight(
            MediaQuery.of(context).size
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            
            children: [
              Logo(),
          
              Wrap(
                direction: Axis.vertical,
                children: [
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 1,
                    pageY: 1,
                    image: const AssetImage('assets/images/playbutton.png'),
                  ),
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 2,
                    pageY: 0, 
                    image: const AssetImage('assets/images/settingsbutton.png')
                  ),
            
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 0,
                    pageY: 0,
                    image: const AssetImage('assets/images/creditsbutton.png')
                  ),
                ],
              ),
          
              ElevatedButton(
                onPressed: () => widget.audioPlayer.stop(), 
                child: Text('stop music')
              ),
            ],
          ),
      ),
    );
  }
}

class MapAlike extends StatefulWidget {
  const MapAlike({
    super.key,
    required this.factor,
    required this.child
  });

  final double factor;
  final Widget child;

  @override
  State<MapAlike> createState() => _MapAlikeState();
}

class _MapAlikeState extends State<MapAlike> {
  
  Offset mousePosition = const Offset(1000, 500);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => {
        setState(() => mousePosition = event.position)
      },
      child: Transform.translate(
        offset: (mousePosition - Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2)) * -widget.factor,

        child: widget.child,
      )
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  double musicVolume = 0.2;
  double soundVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    return MapAlike(
      factor: 0.2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.pressStart2p(
                fontSize: 30
              ),
            ),
    
            Text(
              'Music Volume',
              style: GoogleFonts.pressStart2p(
    
              ),
            ),
    
            Slider(
              value: musicVolume, 
              onChanged: (value) => setState(() => musicVolume = value)
            ),
    
            Text(
              'Sound Volume',
              style: GoogleFonts.pressStart2p(
    
              ),
            ),
    
            Slider(
              value: soundVolume, 
              onChanged: (value) => setState(() => soundVolume = value)
            ),
    
            ElevatedButton(
              onPressed: () => widget.changePage(1, 0), 
              child: Text('back')
            ),
          ],
        ),
      ),
    );
  }
}

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: [

          ElevatedButton(
            onPressed: () => changePage(1, 0), 
            child: Text('back')
          ),

          Text('CREDITS'),
          Text('Game made by AchoDev')
        ],
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  const _MenuButton({
    super.key,
    required this.changePage,
    required this.pageX,
    required this.pageY,
    required this.image,
  });

  final int pageX;
  final int pageY;
  final Function(int, int) changePage;
  final AssetImage image;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hovered = true),
      onExit: (event) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => widget.changePage(widget.pageX, widget.pageY)),
        child: SizedBox(
          width: 300,
          child: AnimatedScale(
            
            scale: hovered ? 1.3 : 1,
            
            curve: Curves.bounceOut,
            
            duration: const Duration(milliseconds: 200),
            child: Image(
              image: widget.image,
            )
          ),
        )
      ),
    );
  }
}

class Logo extends StatefulWidget {
  const Logo({
    super.key,
  });

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin{
  
  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (60000 / 170 / 2).toInt())
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut)
    );

    _titleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
  }

  late Animation<double> _scaleAnimation;
  late AnimationController _titleController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: 500,
            child: Image(image: AssetImage('assets/images/logo.png'))
          ),
        );
      }
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
  JoinServerScreen({
    super.key,
    required this.changePage
  });

  final Function changePage;

  final usernameController = TextEditingController();
  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 0), 
            child: Text('back')
          ),

          Text('Join Server'),
        
           TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Enter Username',
            ),
          ),
           TextField(
            controller: ipController,
            decoration: InputDecoration(
              hintText: 'IP'
            ),
          ),
    
          ElevatedButton(
            onPressed: () {
              
              SocketClient.joinLocalLobby(usernameController.text, ipController.text);
    
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lobby()));
            }, 
            child: Text('Join')
          )
        ],
      ),
    );
  }
}

