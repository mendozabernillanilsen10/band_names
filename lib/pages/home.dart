import 'dart:io';

import 'package:band_names/model/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage  extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1',  name: 'The Beatles', votes: 1),
    Band(id: '2', name: 'Queen', votes: 2),
    Band(id: '3', name: 'Led Zeppelin', votes:3),
    Band(id: '4',name: 'Pink Floyd', votes: 4),
    Band(id: '5',name: 'AC/DC', votes:1),
    Band(id: '6',name: 'Metallica', votes:3),
  ];
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Band ',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _banTitle(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),

    );
  }

  Widget _banTitle(Band ban) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100], // ✅ Corregido
        child: Text(ban.name.substring(0, 2)),
      ),
      title: Text(ban.name),
      subtitle: Text(
        '${ban.votes} votes',
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        setState(() {
          ban.votes++;
        });
      },
    );
  }


void addNewBand() {
  final TextEditingController controllertxt = TextEditingController();

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a new band'),
          content: TextField(
            controller: controllertxt,
            decoration: InputDecoration(hintText: 'Band name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                addBand(controllertxt.text);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Add a new band'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: controllertxt,
              placeholder: 'Band name',
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Add'),
              onPressed: () {
                addBand(controllertxt.text);
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}

void addBand(String name) {
  final trimmedName = name.trim();
  if (trimmedName.isEmpty) return;

  setState(() {
    bands.add(Band(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
      votes: 0,
    ));
  });

  Navigator.pop(context);
}
}

