import 'dart:io';
import 'package:band_names/model/band.dart';
import 'package:band_names/servicces/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.on('bands', _activarSocket);
    super.initState();
  }

  void _activarSocket(dynamic data) {
    bands = (data as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.off("bands");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketService>(context);
    final serverStatus = socketServices.serverStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        actions: <Widget>[
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
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketServices = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed:( _ )=>socketServices.socket.emit("delete-band", {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 16),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text('Delete Band', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2).toUpperCase()),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: ()=>socketServices.socket.emit("votar-banderolo", {'id': band.id}),
      ),
    );
  }

  void addNewBand() {
    final TextEditingController textController = TextEditingController();

    if (Platform.isAndroid) {
      // Android dialog
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('New band name'),
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text),
                ),
              ],
            ),
      );
    } else {
      // iOS dialog
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: Text('nueva banda '),
              content: CupertinoTextField(controller: textController),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('nuevo'),
                  onPressed: () => addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Dismiss'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    }
  }

  void addBandToList(String name) {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketServices.socket.emit("nuevo-banda", {'name': name});
    }
    Navigator.pop(context); // Close dialog
  }
}
