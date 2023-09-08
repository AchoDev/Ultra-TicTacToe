import 'dart:async';
import 'dart:math';

import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'Server.dart';

class SocketClient {
  static io.Socket? _socket;

  static Future<bool> connect(String ip, String username, int picture, [Function? callBack]) async {

    if(_socket == null) {
            
      Completer<bool> completer = Completer<bool>();

      _socket = io.io('http://$ip:8000', <String, dynamic>{
        'transports': ['websocket'],
        'force new connection': true,
      });

      _socket!.on('connect', (_) {
        _socket!.emit('playerInformation', {
          'username': username,
          'picture': picture,
        });
        
        completer.complete(true);

        completer = Completer<bool>();
      });

      _socket!.onConnectError((_) {
        print('connection error');

        completer.complete(false);

        completer = Completer<bool>();
      });


      _socket!.onError((e) {
        print('Error: $e');
      });

      return completer.future;
    } else {

      _socket!.disconnect();
      _socket = null;
      return await connect(ip, username, picture, callBack);
    }
  }

  static void makeMove(int global, int local) {
    _socket!.emit('playermove', [global, local]);
  }

  static void listenFor(String event, Function(dynamic) callback) {
    if(_socket == null) {
      print('socket is null but still trying to listen to something!');
      return;
    }

    _socket!.on(event, ((data) {
      print('DATA: $data');
      callback(data);
    }));
  }

<<<<<<< Updated upstream
  static void startGame() {
    _socket!.emit('startgame');
=======
  static void startGame(String map) {
    _socket!.emit('startgame', map);
>>>>>>> Stashed changes
  }

  static Process? _nodeProcess;

  static Future<bool> hostLocalLobby(String username, int picture, Function(bool) callback) async {

    // _nodeProcess = await Process.start('node', ['server/server.js']);

    // print('node process started!');



    if (!await GameServer.startServer()) {
      return false;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final bool isConnected = await connect('localhost', username, picture);

    callback(isConnected);

    return isConnected;

    // _nodeProcess!.stdout.transform(utf8.decoder).listen((data) async {
    //   // print('Node.js Server Output: $data');
      
    //   final bool isConnected = await connect('localhost');

    //   if(!isConnected) stopConnection();
    //   callback(isConnected);
    //   if(!completer.isCompleted) completer.complete(isConnected);
      
    // });

    // _nodeProcess!.stderr.transform(utf8.decoder).listen((data) {
    //   print('Node.js Server Error: $data');
    //   if(!completer.isCompleted) {
    //     completer.complete(false);
    //     callback(false);
    //   }
    // });

  }

  static Future<bool> joinLocalLobby(String username, int picture, String ip) async {
    late bool result;
    
    if(_socket == null) result = await connect(ip, username, picture);

    if(result) {
      _socket!.emit('joinlobby', {'data': username});
      return true;
    } else {
      return false;
    }
  }

  static void stopConnection() {
    if(_socket != null) {
      _socket!.close();
      _socket!.dispose();
    }
    _socket = null;

    GameServer.stopServer();

    print('disconnect');
  }
}