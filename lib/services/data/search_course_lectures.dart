import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/categories_model.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';

class SearchDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Category>> getAllCategories() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("courseCollectionName")
        .get();

    List<Category> categories = querySnapshot.docs.map((doc) {
      return Category.fromMap(doc.data());
    }).toList();

    return categories;
  }

  Future<List<Course>> fetchAllCourses(
      {String? filterType, String? searchQuery}) async {
    try {
      List<Course> courses = [];
      List<Category> categories = await getAllCategories();

      for (Category category in categories) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('courses')
                .doc('kGrTotd8SFOUzsUH9Hpz')
                .collection(category.collectionName)
                .get();

        querySnapshot.docs
            .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          Map<String, dynamic>? data = document.data();

          if ((searchQuery == null ||
                  data!['title']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())) &&
              (filterType == null)) {
            courses.add(Course.fromMap(data!));
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
