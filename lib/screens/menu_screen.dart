// menu_screen.dart

import 'package:flutter/material.dart';
import 'package:vidyamani/screens/chatgpt_page.dart';

import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/live_stream.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/services/auth/authentication.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              final navigator = Navigator.of(context);

              navigator.push(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              final navigator = Navigator.of(context);

              navigator.push(
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () async {
              await AuthenticationServices().signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
          ),
          ListTile(
            title: Text('Ask GPT'),
            onTap: () {
              final navigator = Navigator.of(context);

              navigator.push(
                MaterialPageRoute(
                  builder: (_) => ChatGPTPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
