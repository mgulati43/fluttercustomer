import 'package:flutter/material.dart';


class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 22, 40, 1),
        title: Text("Smart Dine"),
      ),
      body: Container(
        child: Text(
          'Notes Page',
          style: TextStyle(
            color: Color.fromRGBO(19, 22, 40, 1),
            fontFamily: 'Courgette',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
      ),

    );
  }
}
