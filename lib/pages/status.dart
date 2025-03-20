import 'package:band_names/servicces/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class statupague extends StatefulWidget {
  const statupague({super.key});

  @override
  State<statupague> createState() => _statupagueState();
}

class _statupagueState extends State<statupague> {
  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketService>(context);
    final serverStatus = socketServices.serverStatus;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text('SERVER ESTATUS ${socketServices.serverStatus}'),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                serverStatus == ServerStatus.Online
                    ? Icons.check_circle
                    : Icons.offline_bolt,

                color:
                serverStatus == ServerStatus.Online
                    ? Colors.blue.shade300
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message_rounded),
        onPressed: () {
          socketServices.socket.emit('nuevo-mensaje', {
            'nombre': 'SMITH DE LOS CIELOS',
            'mensaje': 'Hola, estoy enviando un mensaje desde el cliente',
          });
        },
      ),
    );
  }
}
