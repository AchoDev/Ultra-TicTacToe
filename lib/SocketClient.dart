import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  static io.Socket? _socket;

  static void connect([Function? callBack]) {

    if(_socket == null) {
      _socket = io.io('http://localhost:8000', <String, dynamic>{
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

  static void startGame() {
    print('a');
    _socket!.emit('startgame');
  }

  static void joinLocalLobby(String username) {
    if(_socket == null) connect();
    _socket!.emit('joinlobby', {'data': username});
  }
}