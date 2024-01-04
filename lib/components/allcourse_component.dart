import 'package:flutter/material.dart';
import 'package:vidyamani/components/courses_list_tile.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/categories_model.dart';
import 'package:vidyamani/services/data/allcoursedata_services.dart';

class AllCoursesPage extends StatelessWidget {
  final AllCoursesDataService _allCoursesDataService = AllCoursesDataService();
  final Category selectedCategory;

  AllCoursesPage({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: FutureBuilder<List<AllCourseData>>(
        future: getSelectedCategoryCourses(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<AllCourseData> courses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                AllCourseData course = courses[index];
                return CourseTile(
                  title: course.title,
                  type: course.type,
                  // Pass more properties as needed
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<AllCourseData>> getSelectedCategoryCourses(
      BuildContext context) async {
    switch (selectedCategory.name) {
      case 'Skill Based Courses':
        return await _allCoursesDataService.fetchSkillBasedCourses();
      case 'Human Rights':
        return await _allCoursesDataService.fetchHumanRightsCourses();
      case 'Class Based Course':
        return await _allCoursesDataService.fetchClassBasedCourses();
      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown category: ${selectedCategory.name}'),
            ),
          );
        });
        return [];
    }
  }
}
