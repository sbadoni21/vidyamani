import 'package:flutter/material.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/search_bar.dart';
import 'package:vidyamani/screens/courses_page.dart';
import 'package:vidyamani/services/data/allcoursedata_services.dart';
import 'package:vidyamani/services/data/search_course_lectures.dart';
class SearchBarButton extends StatefulWidget {
  const SearchBarButton({super.key});

  @override
  _SearchBarButtonState createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  List<AllCourseData> searchResults =
      []; // Add a state variable for search results

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
                  SearchBarsection(
                    onSearch: (query) async {
                      List<AllCourseData> results = await SearchDataService()
                          .fetchAllCourses(searchQuery: query);

                      setState(() {
                        searchResults = results;
                      });

                      // Do something with the search results
                      print('Search Results: ${searchResults.asMap()}');
                    },
                  ),
                  const SizedBox(height: 26),
                  const HeadingTitle(title: "Courses"),
                  const SizedBox(height: 16),

                  // Render search results for Courses
                  if (searchResults.isNotEmpty)
                    Column(
                      children: [
                        for (var course in searchResults)
                          ListTile(
                            title: Text(course.title),
                            subtitle: Text(course.type),
                            // Add more details or customize as needed
                          ),
                      ],
                    ),
                  // End of Courses

                  const SizedBox(height: 16),
                  const HeadingTitle(title: "Lectures"),
                  const SizedBox(height: 16),

                  if (searchResults.isNotEmpty)
                    Column(
                      children: [
                        for (var lecture in searchResults)
                          ListTile(
                            title: Text(lecture.title),
                            subtitle: Text(lecture.type),
                            // Add more details or customize as needed
                          ),
                      ],
                    ),
                  // End of Lectures

                  // Your existing widgets for displaying other content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
