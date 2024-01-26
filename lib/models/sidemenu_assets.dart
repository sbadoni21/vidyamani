import 'package:flutter/material.dart';
import 'package:vidyamani/screens/aboutus_page.dart';
import 'package:vidyamani/screens/chatgpt_page.dart';
import 'package:vidyamani/screens/contact_page.dart';
import 'package:vidyamani/screens/home_page.dart';

List<Map<String, dynamic>> sideMenuItems = [
  {
    "icon": Icons.home,
    "text": "Home",
    "key": "home",
    'route': const HomePage()
  },
  {
    "icon": Icons.person,
    "text": "Ask AI",
    "key": "user",
    'route': const ChatGPTPage()
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
    "icon": Icons.logout,
    "text": "Logout",
    "key": "logout",
    "route": () async {}
  }
];
