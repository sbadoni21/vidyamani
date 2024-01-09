import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/models/course_lectures_model.dart';

class LectureDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );

Future<List<Lectures>> fetchLecturesByCourseKey(String lectureKey) async {
  try {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("lectures").doc(lectureKey).get();
    
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      if (data != null) {
        return [Lectures.fromMap(data)];
      } else {
        return [];
      }
    } else {
      return []; 
    }
  } catch (e) {
    logger.i(e);
    return [];
  }
}
Future<String?> fetchLectureUidByIndex(String courseKey, int index) async {
  try {
    DocumentSnapshot courseSnapshot =
        await _firestore.collection("lectures").doc(courseKey).get();

    if (courseSnapshot.exists) {
      if (courseSnapshot['video'] is List) {
        List<Map<String, dynamic>> videos =
            List<Map<String, dynamic>>.from(courseSnapshot['video']);

        // Check if the selected index is within the bounds of the videos list
        if (index >= 0 && index < videos.length) {
          String lectureUid = videos[index]['uid'] as String;
          return lectureUid;
        }
      }
    }
  } catch (e) {
    logger.i(e);
  }

  return null; // Return null if there's an error or the data is not as expected
}




  Future<List<Lectures>> fetchCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("lectures").get();
      logger.i(querySnapshot);
      return querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Check if the required fields are not empty
            if (data['type'] != null &&
                data['title'] != null &&
                data['photo'] != null) {
              return Lectures.fromMap(data);
            } else {
              return null;
            }
          })
          .where((lecture) => lecture != null) // Remove null entries
          .cast<Lectures>() // Cast the filtered list to List<Lectures>
          .toList();
    } catch (e) {
      logger.i(e);
      return [];
    }
  }
}
