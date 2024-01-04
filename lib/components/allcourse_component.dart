import 'package:flutter/material.dart';
import 'package:vidyamani/models/categories_model.dart';
import 'package:vidyamani/services/data/allcoursedata_services.dart';
import 'package:vidyamani/services/data/course_services.dart'; // Import your course service or data provider
class AllCoursesPage extends StatelessWidget {
  final AllCoursesDataService _allCoursesDataService = AllCoursesDataService();
  final Category selectedCategory;

  AllCoursesPage({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Courses - ${selectedCategory.name}'),
      ),
      body: FutureBuilder<List<AllCourseData>>(
        future: getSelectedCategoryCourses(context), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<AllCourseData> courses = snapshot.data ?? [];
            // Build UI to display courses
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                AllCourseData course = courses[index];
                return ListTile(
                  title: Text(course.title),
                  subtitle: Text(course.type),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
    );
  }

Future<List<AllCourseData>> getSelectedCategoryCourses(BuildContext context) async {
  switch (selectedCategory.name) {
    case 'Skill Based Courses':
      return await _allCoursesDataService.fetchSkillBasedCourses();
    case 'Human Rights':
      return await _allCoursesDataService.fetchHumanRightsCourses();
    case 'Class Based':
      return await _allCoursesDataService.fetchClassBasedCourses();
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unknown category: ${selectedCategory.name}'),
        ),
      );
      return [];
  }
}

}
