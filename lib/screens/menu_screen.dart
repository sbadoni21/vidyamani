import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vidyamani/screens/home_page.dart';

class MenuScreen extends StatefulWidget {
  final ZoomDrawerController zoomDrawerController;

  const MenuScreen({Key? key, required this.zoomDrawerController})
      : super(key: key);

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
            title: Text('Item 1'),
            onTap: () {
              final navigator = Navigator.of(context);
              widget.zoomDrawerController
                  .close!(); // Close the drawer using widget.zoomDrawerController
              navigator.push(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              final navigator = Navigator.of(context);
              widget.zoomDrawerController
                  .close!(); // Close the drawer using widget.zoomDrawerController
              navigator.push(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            },
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}
