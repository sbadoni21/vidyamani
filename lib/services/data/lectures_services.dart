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
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

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
          .where((lecture) => lecture != null)
          .cast<Lectures>() 
          .toList();
    } catch (e) {
      logger.i(e);
      return [];
    }
  }

  Future<double> calculateAverageRating(String lectureKey) async {
    try {
      DocumentSnapshot lectureDoc =
          await _firestore.collection('lectures').doc(lectureKey).get();

      if (lectureDoc.exists) {
        List<dynamic>? videos = lectureDoc['video'];

        if (videos != null) {
          double totalRating = 0;
          int totalComments = 0;
          for (var video in videos) {
            List<dynamic>? comments = video['comments'];

            if (comments != null) {
     
              for (var comment in comments) {
                String rating = comment['rating'];

                if (isNumeric(rating)) {
                  totalRating += double.parse(rating);
                  totalComments++;
                }
              }
            }
          }

          double averageRating =
              totalComments > 0 ? totalRating / totalComments : 0;

          return averageRating;
        }
      }

      return 0; 
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0;
    }
  }



  bool isNumeric(String value) {

    return double.tryParse(value) != null;
  }





Future<void> updateOverallRating(String courseKey, double overallRating) async {
  try {
    final DocumentReference lectureDocRef =
        _firestore.collection('lectures').doc(courseKey);

    final DocumentSnapshot lectureSnapshot = await lectureDocRef.get();

    if (lectureSnapshot.exists) {
      final Map<String, dynamic> lectureData =
          lectureSnapshot.data() as Map<String, dynamic>;

      if (lectureData.containsKey('overallRating')) {
        await lectureDocRef.update({
          'overallRating': overallRating,
        });
      } else {
        await lectureDocRef.set({
          'overallRating': overallRating,
        }, SetOptions(merge: true));
      }
    } else {
      print('Document with ID $courseKey does not exist.');
    }
  } catch (e) {
    print('Error updating overall rating: $e');
  }
}

  
}








