import 'package:flutter/material.dart';

class Contactus extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("Contactus"),
        ),
        body: Column(children: [
        TextFormField(
        decoration: InputDecoration(
        hintText: 'Enter your name',
          labelText: 'contactus',
          prefixIcon: Icon(Icons.account_circle_rounded,size: 40),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),

    ),
        ]));
  }
}
