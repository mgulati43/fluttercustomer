import 'package:flutter/material.dart';
import './menu_header.dart';
import 'HomeScreen.dart';
import 'Profile.dart';


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
          menuItem(1, "My Orders", Icons.emoji_food_beverage),
          menuItem(1, "Notifications", Icons.emoji_food_beverage),
          menuItem(1, "About Us", Icons.emoji_food_beverage),
          menuItem(1, "Contact us", Icons.emoji_food_beverage),
          menuItem(1, "Feedback", Icons.emoji_food_beverage),
          menuItem(1, "Share App", Icons.emoji_food_beverage),
          menuItem(1, "Logout", Icons.emoji_food_beverage)
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
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (id == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            }
            // } else if (id == 2) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => OrdersPage()),
            //   );
            // } else if (id == 3) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => CalendarPage()),
            //   );
            // } else if (id == 4) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => NotesPage()),
            //   );
            // } else if (id == 5) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => SettingsPage()),
            //   );
            // } else if (id == 6) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginScreen()),
            //   );
            // }
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
