import 'package:flutter/material.dart';

class MenuHeader extends StatefulWidget {
  @override
  _MenuHeaderState createState() => _MenuHeaderState();
}

class _MenuHeaderState extends State<MenuHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(19, 22, 40, 1),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('logos/genericUserIcon.png'),
              ),
            ),
          ),
          Text(
            "Hello User Name!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "Users Mobile number",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
