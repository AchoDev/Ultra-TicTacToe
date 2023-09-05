
import 'package:flutter/material.dart';

import 'package:ultra_tictactoe/SocketClient.dart';

import 'Lobby.dart';

import '../shared/PagejumpButton.dart';
import '../shared/JumpOnHover.dart';

class JoinServerScreen extends StatefulWidget {
  JoinServerScreen({
    super.key,
    required this.changePage,
    required this.lobbyKey
  });

  final Function(int, int) changePage;
  final GlobalObjectKey<LobbyState> lobbyKey;

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

                      if(isConnected) {
                        widget.changePage(1, 3);
                        widget.lobbyKey.currentState!.listenForServer();
                      }

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