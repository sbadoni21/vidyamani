import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';

class SearchDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> fetchAllCourses(
      {String? filterType, String? searchQuery}) async {
    try {
      List<Course> courses = [];

      for (String collectionName in [
        'humanRights',
        'skillBased',
        'classBased'
      ]) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('courses')
            .doc('kGrTotd8SFOUzsUH9Hpz')
            .collection(collectionName)
            .get();

        querySnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          if ((searchQuery == null ||
                  data['title']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())) &&
              (filterType == null)) {
            courses.add(Course.fromMap(data));
          }
        });
      }

      return courses;
    } catch (error) {
      print('Error fetching courses: $error');
      throw error;
    }
  }

  Future<List<Videos>> searchVideo(String searchQuery, User user) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('lectures').get();

      List<Videos> searchResults = [];

      for (DocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        if (document.data()?['type'] == 'premium' && user.type == 'free') {
          continue;
        }

        List<Map<String, dynamic>>? videosList =
            (document.data()?['video'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>();

        if (videosList != null) {
          for (Map<String, dynamic> videoMap in videosList) {
            String? videoTitle = videoMap['title']?.toString();
            if ((videoTitle != null &&
                videoTitle.toLowerCase().contains(searchQuery.toLowerCase()))) {
              searchResults.add(Videos.fromMap(videoMap));
            }
          }
        }
      }

      return searchResults;
    } catch (e) {
      print('Error searching videos: $e');
      return [];
    }
  }
}
