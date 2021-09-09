import 'package:flutter/material.dart';
import 'package:flutter_app_testting/ViewOrder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './menu_header.dart';

import 'Contactus.dart';
import 'HomeScreen.dart';
import 'Profile.dart';
import 'ViewOrder.dart';


class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              MenuHeader(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Profile", Icons.emoji_food_beverage),
          menuItem(2, "My Orders", Icons.emoji_food_beverage),
          menuItem(3, "Notifications", Icons.emoji_food_beverage),
          menuItem(4, "About Us", Icons.emoji_food_beverage),
          menuItem(5, "Contact us", Icons.emoji_food_beverage),
          menuItem(6, "Feedback", Icons.emoji_food_beverage),
          menuItem(7, "Share App", Icons.emoji_food_beverage),
          menuItem(8, "Logout", Icons.emoji_food_beverage)
          // menuItem(2, "My Orders", Icons.people_alt_outlined),
          // menuItem(3, "Calendar", Icons.event),
          // menuItem(4, "Notes", Icons.notes),
          // menuItem(5, "Settings", Icons.settings_outlined),
          // menuItem(6, "Sign Out", Icons.logout)
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            if (id == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            }
             else if (id == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewOrder()),
              );
            } else if (id == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            } else if (id == 4) {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            } else if (id == 5) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Contactus()),
              );
            } else if (id == 6) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
