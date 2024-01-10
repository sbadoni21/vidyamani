import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/Notifier/user_state_notifier.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/courses_list_tile.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/testimonals_component.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/services/data/course_services.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class CoursesPage extends ConsumerStatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
  }

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
                future: DataService().fetchCoursesViaUser(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Display error if any
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                        'No courses found.'); 
                  } else {
                    List<Course> courses = snapshot.data!;

                    return SizedBox(
                        height: 170,
                        child: courses.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  Course course = courses[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CourseDetailPage(courses: course),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Tiles(
                                        imagePath: course.photo,
                                        text1: course.type,
                                        text2: course.title,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Text("No featured courses available."),
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
