import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  static io.Socket? _socket;

  static Future<bool> connect(String ip, [Function? callBack]) async {

    if(_socket == null) {

      final Completer<bool> completer = Completer<bool>();

      _socket = io.io('http://$ip:8000', <String, dynamic>{
        'transports': ['websocket'],
      });

      _socket!.onConnect((_) {
        print('connected to server');

        if(!completer.isCompleted) completer.complete(true);
      });

      _socket!.onConnectError((_) {
        print('connection error');

        if(!completer.isCompleted) completer.complete(false);
      });


      _socket!.onError((e) {
        print('Error: $e');
      });

      return completer.future;
    } else {
      _socket!.disconnect();
      return await connect(ip, callBack);
    }
  }

  static void makeMove(int global, int local) {
    _socket!.emit('playermove', [global, local]);
  }

  static void listenFor(String event, Function(dynamic) callback) {
    if(_socket == null) return;

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

    _nodeProcess = await Process.start('node', ['server/server.js']);
    final completer = Completer<bool>();

    _nodeProcess!.stdout.transform(utf8.decoder).listen((data) async {
      // print('Node.js Server Output: $data');
      
      final bool isConnected = await connect('localhost');

      if(!isConnected) stopConnection();
      callback(isConnected);
      if(!completer.isCompleted) completer.complete(isConnected);
      
    });

    _nodeProcess!.stderr.transform(utf8.decoder).listen((data) {
      print('Node.js Server Error: $data');
      if(!completer.isCompleted) {
        completer.complete(false);
        callback(false);
      }
    });

    return completer.future;
  }

  static Future<bool> joinLocalLobby(String username, String ip) async {
    late bool result;
    
    if(_socket == null) result = await connect(ip);

    if(result) {
      _socket!.emit('joinlobby', {'data': username});
      return true;
    } else {
      return false;
    }
  }

  static void stopConnection() {
    if(_nodeProcess != null) _nodeProcess!.kill();
    if(_socket != null) _socket!.disconnect();
  }
}