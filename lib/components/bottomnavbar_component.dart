import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 25,
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: bgColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedLabelStyle: myTextStylefontsize14,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(0);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
            ),
            icon: Icon(
              Icons.home,
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(1);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
            ),
            icon: Icon(
              Icons.search_rounded,
            ),
          ),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(2);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
            ),
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
          ),
          label: "Ask AI",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(3);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
            ),
            icon: Icon(
              Icons.library_books,
            ),
          ),
          label: "Notes",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(4);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
            ),
            icon: Icon(
              Icons.person_pin,
            ),
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
