import 'package:flutter/material.dart';
import 'package:vidyamani/screens/aboutus_page.dart';
import 'package:vidyamani/screens/chatgpt_page.dart';
import 'package:vidyamani/screens/contact_page.dart';
import 'package:vidyamani/screens/live_stream.dart';
import 'package:vidyamani/screens/notes_page.dart';

List<Map<String, dynamic>> sideMenuItems = [
  {"icon": Icons.home, "text": "Home", "key": "home", 'route': const MyNotes()},
  {
    "icon": Icons.person,
    "text": "Ask AI",
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
    "icon": Icons.info,
    "text": "About Us",
    "key": "aboutus",
    'route': AboutAppPage()
  },
  {
    "icon": Icons.video_call,
    "text": "videocall",
    "key": "aboutus",
    'route': LiveStreams()
  },
  {
    "icon": Icons.logout,
    "text": "Logout",
    "key": "logout",
    "route": () async {}
  }
];
