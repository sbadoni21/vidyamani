import 'package:flutter/material.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/screens/courses_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Add state variables or methods as needed

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiles(
            //     imagePath: "lib/assets/images/featuredcourses.png",
            //     text1: "Basic Courses",
            //     text2: "basic course",
            //     pageRoute:
            //         MaterialPageRoute(builder: (context) => CoursesPage())),
          ],
        ),
      ),
    );
  
  }
}
