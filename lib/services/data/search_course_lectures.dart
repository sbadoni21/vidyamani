import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/services/data/allcoursedata_services.dart';

class SearchDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AllCourseData>> fetchAllCourses({String? filterType, String? searchQuery}) async {
    try {
      List<AllCourseData> courses = [];

      for (String collectionName in ['humanRights', 'skillBased', 'classBased']) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('courses')
            .doc('kGrTotd8SFOUzsUH9Hpz')
            .collection(collectionName)
            .get();

        querySnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          if ((searchQuery == null ||
                  data['title'].toString().toLowerCase().contains(searchQuery.toLowerCase())) &&
              (filterType == null ||
                  data['type'] == filterType ||
                  data['title'] == filterType ||
                  data['photo'] == filterType ||
                  data['id'] == filterType)) {
            courses.add(AllCourseData.fromMap(data));
          }
        });
      }

      return courses;
    } catch (error) {
      print('Error fetching courses: $error');
      throw error;
    }
  }
}
