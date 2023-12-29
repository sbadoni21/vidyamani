import 'package:flutter/material.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/testimonals_component.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
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
            SizedBox(
              height: 16,
            ),
            HeadingTitle(title: "Running Courses"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Tiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => CoursesPage())),
                SizedBox(
                  width: 3,
                ),
                Tiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => CoursesPage())),
                SizedBox(
                  width: 3,
                ),
                Tiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => CoursesPage())),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            HeadingTitle(title: "Completed Courses"),
            SizedBox(
              height: 16,
            ),
             Row(
                  children: [
                    Tiles(
                        imagePath: "lib/assets/images/featuredcourses.png",
                        text1: "Basic Courses",
                        text2: "basic course",
                        pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage())),
                    SizedBox(
                      width: 3,
                    ),
                    Tiles(
                        imagePath: "lib/assets/images/featuredcourses.png",
                        text1: "Basic Courses",
                        text2: "basic course",
                        pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage())),
                    SizedBox(
                      width: 3,
                    ),
                    Tiles(
                        imagePath: "lib/assets/images/featuredcourses.png",
                        text1: "Basic Courses",
                        text2: "basic course",
                        pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage())),
                  ],
                ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
