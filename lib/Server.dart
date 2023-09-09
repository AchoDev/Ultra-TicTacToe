
  import 'dart:async';

import 'package:socket_io/socket_io.dart';

class _Player {
  final String username;
  final int picture;
  final Socket socket;
  final bool isHost;

  const _Player({required this.username, required this.picture, required this.socket, required this.isHost});
}

class GameServer {
  static Server io = Server();

  static stopServer() {
    io.close();
    io = Server();

    _players = List.empty(growable: true);
  }

  static List<_Player> _players = List.empty(growable: true);
  static String currentMap = '';

  static bool startServer() {
    try{
      io.on('connection', (socket) {
        print('player connected');

        socket.on('startgame', (data) {
          if(socket == _players[0].socket) {io.emit('hoststartgame', data);}
        });

        socket.on('changeMap', (String data) {
          currentMap = data;

          socket.broadcast.emit('hostchangedmap', data);
        });

        socket.on('playerInformation', (data) {

          bool isHost = _players.isEmpty;

          _players.add(_Player(
            username: data['username'],
            picture: data['picture'],
            socket: socket,
            isHost: isHost,
          ));

          socket.emit('gameinformation', {
              'you': {
                'username': data['username'],
                'picture': data['picture'],
                'isHost': isHost
              },
              'enemy': isHost ? null : {
                'username': _players[0].username,
                'picture': _players[0].picture,
                'isHost': true
              },
              'map': currentMap,
            }
          );

          socket.broadcast.emit('userjoinedlobby', {
            'username': data['username'],
            'picture': data['picture'],
            'isHost': isHost,
          });
        });

        socket.on('disconnect', () {
          _players.removeWhere((player) => player.socket == socket);
          socket.broadcast.emit('playerleave', [
            for(_Player player in _players)
              {'username': player.username, 'isHost': player.isHost}
          ]);
        });
      });

      io.on('connect_error', (e) {
        print(e);
      });

      io.listen(8000);

      return true;
    } catch(e) {
      return false;
    }
  }
}