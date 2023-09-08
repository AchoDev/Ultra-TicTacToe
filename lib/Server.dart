
  import 'dart:async';

import 'package:socket_io/socket_io.dart';

class _Player {
  final String username;
  final Socket socket;
  final bool isHost;

  const _Player({required this.username, required this.socket, required this.isHost});
}

class GameServer {
  static Server io = Server();


  static stopServer() {
    io.close();
    io = Server();
  }

  static List<_Player> players = List.empty(growable: true);

  static bool startServer() {

    try{

      io.on('connection', (socket) {
        print('player connected');

        socket.on('startgame', (data) {
          if(socket == _players[0].socket) {io.emit('hoststartgame', data);}
        });

        socket.on('playerInformation', (data) {
          players.add(_Player(
            username: data, 
            socket: socket,
            isHost: players.isNotEmpty,
          ));

          io.emit('userjoinedlobby', {'username': data, 'playercount': players.length});
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