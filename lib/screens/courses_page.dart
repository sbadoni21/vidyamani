import 'package:flutter/material.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/courses_list_tile.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/testimonals_component.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/services/data/course_services.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              HeadingTitle(title: "My Courses"),
              SizedBox(
                height: 16,
              ),
              FutureBuilder<List<Course>>(
                future: DataService().fetchCoursesViaUser("yourUserId"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Display error if any
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                        'No courses found.'); // Display a message if no courses are available
                  } else {
                    List<Course> courses = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        Course course = courses[index];
                        return CourseTile(
                          title: course.title,
                          type: course.type,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
