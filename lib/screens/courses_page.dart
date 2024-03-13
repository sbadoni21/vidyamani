import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/components/coursestile_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/services/data/course_services.dart';

class CoursesPage extends ConsumerStatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const HeadingTitle(title: "My Courses"),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<List<Course?>>(
                future: DataService().fetchCoursesViaUser(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No courses found.');
                  } else {
                    List<Course?>? courses = snapshot.data;

                    return SizedBox(
                      height: 170,
                      child: courses!.isNotEmpty && courses != null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                Course? course = courses[index];
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
                                      course: course!,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text("No featured courses available."),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
