import 'package:flutter/material.dart';
import 'package:vidyamani/screens/chatgpt_page.dart';
import 'package:vidyamani/screens/contact_page.dart';
import 'package:vidyamani/screens/notes_page.dart';

List<Map<String, dynamic>> sideMenuItems = [
  {"icon": Icons.home, "text": "Home", "key": "home", 'route': const MyNotes()},
  {
    "icon": Icons.person,
    "text": "ChatGPT",
    "key": "user",
    'route': ChatGPTPage()
  },
  {
    "icon": Icons.contact_mail,
    "text": "Contact Us",
    "key": "contact",
    'route': ContactUsPage(),
  },
  {
    "icon": Icons.logout,
    "text": "Logout",
    "key": "logout",
    "route": () async {}
  }
];
