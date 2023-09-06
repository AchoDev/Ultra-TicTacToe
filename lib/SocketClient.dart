import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'Server.dart';

class SocketClient {
  static io.Socket? _socket;

  static Future<bool> connect(String ip, String username, [Function? callBack]) async {
    print(_socket);
    if(_socket == null) {
      
      print(ip);
      
      Completer<bool> completer = Completer<bool>();

      _socket = io.io('http://$ip:8000', <String, dynamic>{
        'transports': ['websocket'],
      });

      _socket!.on('connect', (_) {
        _socket!.emit('playerInformation', username);
        
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

      print('aaa');

      _socket!.disconnect();
      _socket = null;
      return await connect(ip, username, callBack);
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

  static void startGame() {
    print('a');
    _socket!.emit('startgame');
  }

  static Process? _nodeProcess;

  static Future<bool> hostLocalLobby(String username, Function(bool) callback) async {

    // _nodeProcess = await Process.start('node', ['server/server.js']);

    // print('node process started!');



    if (!await GameServer.startServer()) {
    
      print('no!!!!');
      return false;
    }

    print('i am connected ,:)');

    final bool isConnected = await connect('localhost', username);

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

  static Future<bool> joinLocalLobby(String username, String ip) async {
    late bool result;
    
    if(_socket == null) result = await connect(ip, username);

    if(result) {
      _socket!.emit('joinlobby', {'data': username});
      return true;
    } else {
      return false;
    }
  }

  static void stopConnection() {
    if(_nodeProcess != null) _nodeProcess!.kill();
    if(_socket != null) _socket!.dispose();
    _socket = null;

    GameServer.stopServer();

    print('disconnect');
  }
}