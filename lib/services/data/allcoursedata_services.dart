import 'package:cloud_firestore/cloud_firestore.dart';

class AllCoursesDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AllCourseData>> fetchHumanRightsCourses() async {
    return await fetchCoursesFromCollection('humanRights');
  }

  Future<List<AllCourseData>> fetchSkillBasedCourses() async {
    return await fetchCoursesFromCollection('skillBased');
  }

  Future<List<AllCourseData>> fetchClassBasedCourses() async {
    return await fetchCoursesFromCollection('classBased');
  }

  Future<List<AllCourseData>> fetchCoursesFromCollection(
      String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('courses')
          .doc('kGrTotd8SFOUzsUH9Hpz')
          .collection('$collectionName')
          .get();
      List<AllCourseData> courses = [];
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        courses.add(AllCourseData.fromMap(data));
      });
      return courses;
    } catch (error) {
      print('Error fetching courses: $error');
      throw error;
    }
  }
}

// course_model.dart

class AllCourseData {
  final String id;
  final String title;
  final String type;
  final String photo;

  AllCourseData({
    required this.id,
    required this.title,
    required this.type,
    required this.photo,
  });

  factory AllCourseData.fromMap(Map<String, dynamic> map) {
    return AllCourseData(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      photo: map['photo'] ?? '',
    );
  }
}
