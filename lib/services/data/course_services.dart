import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/models/course_lectures_model.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<List<Course>> fetchCollectionData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("courses")
          .doc("kGrTotd8SFOUzsUH9Hpz")
          .collection("humanRights")
          .get();
      logger.i(querySnapshot);

      List<Course> courses = querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data['type'] != null &&
                data['title'] != null &&
                data['photo'] != null) {
              return Course.fromMap(data);
            } else {
              return null;
            }
          })
          .where((course) => course != null)
          .cast<Course>()
          .toList();

      return courses;
    } catch (e) {
      logger.i(e);
      return [];
    }
  }

  Future<List<Course>> fetchCoursesViaUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection("users").doc(userId).get();
      logger.i(userSnapshot);

      List<String> courseIds =
          List<String>.from(userSnapshot.get("myCourses") ?? []);

      List<Course> courses = await Future.wait(courseIds.map((courseId) async {
        DocumentSnapshot courseSnapshot =
            await _firestore.collection("courses").doc(courseId).get();
        Map<String, dynamic>? data =
            courseSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          return Course.fromMap(data);
        } else {
          return Course(
            type: '',
            title: '',
            photo: '',
            lectures: '',
            price: '',
            teacher: '',
            lectureKey: '',
          );
        }
      }));

      return courses;
    } catch (e) {
      logger.i(e);
      return [];
    }
  }

  Future<List<Videos>> fetchLecturesWithLectureKey(String lectureKey) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection("lectures").doc(lectureKey).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Log the video data
          logger.i("Video data: $data");

          List<Videos> videos = (data['video'] as List<dynamic>?)
                  ?.map<Videos>(
                      (value) => Videos.fromMap(value as Map<String, dynamic>))
                  .where((video) => video != null)
                  .cast<Videos>()
                  .toList() ??
              [];

          return videos;
        } else {
          logger.i("No video data found");
          return [];
        }
      } else {
        logger.i("Document does not exist for lecture key: $lectureKey");
        return [];
      }
    } catch (e) {
      // Use the logger inside the catch block for error logging
      logger.i("Error fetching videos: $e");
      // Return an empty list in case of an error
      return [];
    }
  }
}
