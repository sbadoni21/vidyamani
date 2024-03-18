import 'package:flutter/material.dart';
import 'package:vidyamani/components/courselongtile.dart';
import 'package:vidyamani/components/courses_list_tile.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/categories_model.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/services/data/allcoursedata_services.dart';
import 'package:vidyamani/services/data/course_services.dart';

class AllCoursesPage extends StatelessWidget {
  final Category selectedCategory;

  AllCoursesPage({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: FutureBuilder<List<Course>>(
        future: getSelectedCategoryCourses(selectedCategory.collectionName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Course> courses = snapshot.data ?? [];
            return ListView.builder(
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
                      padding: const EdgeInsets.fromLTRB(20.0,10,20,10),
                      child: CourseLongTiles(course: course),
                    ));
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Course>> getSelectedCategoryCourses(String collectionName) async {
   
        return await DataService().fetchCollectionDatawithName(collectionName);
    
     }
}
