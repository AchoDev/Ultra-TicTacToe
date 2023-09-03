



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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme(),
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

    _audioPlayer.play(DeviceFileSource('audio/menumusic.mp3'));
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
            height: MediaQuery.of(context).size.height * 4,
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

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LocalMultiplayerPage(
                      changePage: changePage,
                    ),

                    PlayScreen(
                      changePage: changePage,
                    ),

                    SingleplayerScreen(
                      changePage: changePage
                    )

                  ],
                ),


                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SetupScreen(
                      changePage: changePage,
                    ),
                    JoinServerScreen(
                      changePage: changePage
                    ),

                    SetupScreen(
                      changePage: changePage,
                    ),

                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lobby(
                      changePage: changePage,
                    ),
                  ],
                ),

              ],
            ),
          ),
        
        ],
      ),
    );
  }
}

class SingleplayerScreen extends StatelessWidget {
  const SingleplayerScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
     return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 1),
            child: Text('back')
          ),
        ],
      ),
    );
  }
}

class LocalMultiplayerPage extends StatelessWidget {
  const LocalMultiplayerPage({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 1),
            child: const Text('back')
          ),
        ],
      ),
    );
  }
}


class PlayScreen extends StatelessWidget {
  const PlayScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          ElevatedButton(
            onPressed: () => changePage(1, 0),
            child: Text('back')
          ),

          FilledButton(
            onPressed: () => changePage(0, 1),
            child: Text(
              'Singleplayer',
              style: GoogleFonts.pressStart2p(
                fontSize: 10
              ),
            )
          ),


          FilledButton(
            onPressed: () => changePage(2, 1),
            child: Text(
              'Local Multiplayer',
              style: GoogleFonts.pressStart2p(
                fontSize: 10
              ),
            )
          ),

          FilledButton(
            onPressed: () => changePage(1, 2),
            child: Text(
              'Online Multiplayer',
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
              const Logo(),
          
              Wrap(
                direction: Axis.vertical,
                children: [
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 1,
                    pageY: 1,
                    image: const AssetImage('images/playbutton.png'),
                  ),
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 2,
                    pageY: 0, 
                    image: const AssetImage('images/settingsbutton.png')
                  ),
            
                  _MenuButton(
                    changePage: widget.changePage, 
                    pageX: 0,
                    pageY: 0,
                    image: const AssetImage('images/creditsbutton.png')
                  ),
                ],
              ),
          
              ElevatedButton(
                onPressed: () => widget.audioPlayer.stop(), 
                child: const Text('stop music')
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
            child: const Text('back')
          ),

          const Text('CREDITS'),
          const Text('Game made by AchoDev')
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
          child: const SizedBox(
            width: 500,
            child: Image(image: AssetImage('images/logo.png'))
          ),
        );
      }
    );
  }
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('How do you set up a Server?'),

          PagejumpButton(
            changePage: changePage, 
            pageX: 1, 
            pageY: 2, 
            text: 'Back'
          ),



          Text("I don't know ")
        ],
      ),
    );
  }
}

class PagejumpButton extends StatefulWidget {
  const PagejumpButton({
    super.key,
    required this.changePage,
    required this.pageX,
    required this.pageY,
    required this.text,
  });

  final String text;
  final int pageX;
  final int pageY;
  final Function(int, int) changePage;

  @override
  State<PagejumpButton> createState() => _PagejumpButtonState();
}

class _PagejumpButtonState extends State<PagejumpButton> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return JumpOnHover(
      child: FilledButton(
        onPressed: () => widget.changePage(widget.pageX, widget.pageY),
        child: Text(widget.text),
      )
    );
  }
}

class JumpOnHover extends StatefulWidget {
  const JumpOnHover({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<JumpOnHover> createState() => _JumpOnHoverState();
}

class _JumpOnHoverState extends State<JumpOnHover> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hovered = true),
      onExit: (event) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.3 : 1,
        
        curve: Curves.bounceOut,
        
        duration: const Duration(milliseconds: 200),
        child: widget.child
      ),
    );
  }
}

class JoinServerScreen extends StatefulWidget {
  JoinServerScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

  @override
  State<JoinServerScreen> createState() => _JoinServerScreenState();
}

class _JoinServerScreenState extends State<JoinServerScreen> {
  final usernameController = TextEditingController();

  final ipController = TextEditingController();

  String errorText = '';

  void raiseError(String error) async {
    setState(() => errorText = error);
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() => errorText = '');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,

      child: FractionallySizedBox(
        widthFactor: 0.3,
        heightFactor: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            const Text(
              'Join Server',
              style: TextStyle(
                fontSize: 30
              ),
            ),

            AnimatedOpacity(
              opacity: errorText == '' ? 0 : 1, 
              duration: const Duration(milliseconds: 150),
              child: Stack(
                children: [
                  Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6,
                    ),
                  ),

                  Text(
                    errorText,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: PagejumpButton(
                changePage: widget.changePage,
                pageX: 1,
                pageY: 1,
                text: 'Back',
              )
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: PagejumpButton(
                changePage: widget.changePage,
                pageX: 0,
                pageY: 2,
                text: 'How to create a server',
              )
            ),
      
          
             TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter Username',
                border: OutlineInputBorder(),
                fillColor: Colors.blue,
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
              ),
            ),
             TextField(
              controller: ipController,
              decoration: const InputDecoration(
                hintText: 'IP',
                border: OutlineInputBorder(),
                fillColor: Colors.blue,
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
              ),
            ),
          
            JumpOnHover(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {

                    if(usernameController.text == '') {
                      raiseError('Provide a Username');
                      return;
                    }

                    if(ipController.text == '') {
                      raiseError('Provide an IP Address');
                      return;
                    }

                    SocketClient.joinLocalLobby(usernameController.text, ipController.text);
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lobby()));
                  }, 
                  child: const Text('Join')
                ),
              ),
            ),

            JumpOnHover(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    
                    if(usernameController.text == '') {
                      raiseError('Provide a Username');
                      return;
                    }

                    SocketClient.hostLocalLobby(usernameController.text, (isConnected) {
                      Navigator.of(context).pop();

                      if(isConnected) widget.changePage(1, 3);

                      else raiseError('Connection Error');
                    });

                    showDialog(
                      barrierDismissible: false,
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Starting local server'),
                          
                          content: const SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(), 
                            ),
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                SocketClient.stopConnection();
                              },

                              child: const Text('Cancel')
                            ),
                          ],
                        );
                      }
                    );

                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lobby()));
                  }, 
                  child: const Text('Host')
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

