import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    initConfig();
  }

  void initConfig() {
    // Inicializar conexión
    _socket = IO.io('http://192.168.18.40:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('🔗 Conectado al servidor');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('❌ Desconectado del servidor');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('mensaje', (payload) {
      print('📩 Mensaje recibido: $payload');
      print('Nombre: ${payload['nombre'] ?? ''}');
    });

    _socket.on('nuevo-mensaje', (payload) {
      print('🆕 NUEVO MENSAJE');
      print('Nombre: ${payload['nombre'] ?? ''}');
      print('Mensaje: ${payload['mensaje'] ?? ''}');
    });

  }
}
