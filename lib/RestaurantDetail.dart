
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class RestDetail extends StatelessWidget {
  final RestaurantJsonParser rest;
  // receive data from the FirstScreen as a parameter
  RestDetail({required this.rest});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white24,
            title: Center(
              child: Text(
          rest.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15.0),
        ),
            )
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
