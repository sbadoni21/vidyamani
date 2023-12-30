import 'package:flutter/material.dart';
import 'package:vidyamani/components/categories_component.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/search_bar.dart';
import 'package:vidyamani/screens/courses_page.dart';

class SearchBarButton extends StatefulWidget {
  const SearchBarButton({super.key});

  @override
  _SearchBarButtonState createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarsection(),
                  const SizedBox(height: 26),
                  const HeadingTitle(title: "Courses"),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Tiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        Tiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        Tiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const HeadingTitle(title: "Lectures"),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const HeadingTitle(title: "Lectures"), // Duplicate?
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                        SizedBox(width: 3),
                        CiruclarTiles(
                          imagePath: "lib/assets/images/featuredcourses.png",
                          text1: "Basic Courses",
                          text2: "basic course",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => CoursesPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
