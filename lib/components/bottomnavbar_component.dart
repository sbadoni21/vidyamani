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
      iconSize: 26,
      selectedItemColor: Colors.white,
      backgroundColor: bgColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(0);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              Icons.search_rounded,
            ),
          ),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(2);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              Icons.library_books,
            ),
          ),
          label: "My Courses",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.onTap(3);
            },
            style: IconButton.styleFrom(
              elevation: 0,
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
