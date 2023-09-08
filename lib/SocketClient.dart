import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  static io.Socket? _socket;

  static void connect(String ip, [Function? callBack]) {
    print('ip: $ip');
    if(_socket == null) {
      _socket = io.io('http://$ip:8000', <String, dynamic>{
        'transports': ['websocket'],
      });

      _socket!.onConnect((_) {
        print('connected to server');
        if(callBack != null) callBack();
      });

      _socket!.onError((e) {
        print('Error: $e');
      });
    }
  }

  static void makeMove(int global, int local) {
    _socket!.emit('playermove', [global, local]);
  }

  static void listenFor(String event, Function(dynamic) callback) {
    _socket!.on(event, ((data) {
      print('DATA: $data');
      callback(data);
    }));
  }

<<<<<<< Updated upstream
  static void startGame() {
    print('a');
    _socket!.emit('startgame');
=======
  static void startGame(String map) {
    _socket!.emit('startgame', map);
>>>>>>> Stashed changes
  }

  static void joinLocalLobby(String username, String ip) {
    if(_socket == null) connect(ip);
    _socket!.emit('joinlobby', {'data': username});
  }
}