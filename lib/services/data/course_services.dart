import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/crousal_model.dart';
import 'package:vidyamani/models/user_model.dart';

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

  Future<List<Course>> fetchUpcomingCoursesCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("upcomingCourses").get();
      DateTime nowLocal = DateTime.now();
      List<Course> courses = querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('startTime') && data['startTime'] != null) {
              DateTime startTime = parseCustomDate(data['startTime']);
              if (nowLocal.isBefore(startTime)) {
                return Course.fromMap(data);
              } else {
                return null;
              }
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

  Future<List<Course>> fetchFeaturedCoursesCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("featuredCourses").get();
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



Future<Course?> fetchCarousalCourse(Carousal carosual) async {
  try {
    DocumentSnapshot<Object?> documentSnapshot = await _firestore
        .collection("courses")
        .doc('kGrTotd8SFOUzsUH9Hpz')
        .collection(carosual.courseCollection)
        .doc(carosual.courseKey)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        Course course = Course.fromMap(data);
        return course;
      } else {
        return null;
      }
    } else {
      return null; 
    }
  } catch (e) {
    logger.i(e);
    return null; 
  }
}



  DateTime parseCustomDate(String dateString) {
    try {
      if (dateString.isEmpty) {
        throw FormatException("Empty date string");
      }
      List<String> dateTimeParts = dateString.split('T');
      if (dateTimeParts.length == 2) {
        String datePart = dateTimeParts[0];
        String timePart = dateTimeParts[1];
        List<String> dateComponents = datePart.split('-');
        List<String> timeComponents = timePart.split(':');
        int year = int.parse(dateComponents[0]);
        int month = int.parse(dateComponents[1]);
        int day = int.parse(dateComponents[2]);
        int hour = int.parse(timeComponents[0]);
        int minute = int.parse(timeComponents[1]);
        DateTime localDateTime = DateTime(year, month, day, hour, minute);
        return localDateTime;
      } else {
        throw FormatException("Invalid date format");
      }
    } catch (e) {
      print("Error in parseCustomDate: $e, Date String: $dateString");
      throw Exception("Error parsing date: $e");
    }
  }

  Future<List<Course>> fetchCollectionDatawithName(
      String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("courses")
          .doc("kGrTotd8SFOUzsUH9Hpz")
          .collection(collectionName)
          .get();
      logger.i(querySnapshot);

      List<Course> courses = querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data['type'] != null) {
              return Course.fromMap(data);
            } else {
              return null;
            }
          })
          .where((course) => course != null)
          .cast<Course>()
          .toList();
      Future<List<Course>> fetchFeaturedCollectionData() async {
        try {
          QuerySnapshot querySnapshot =
              await _firestore.collection("featuredCourses").get();
          DateTime nowLocal = DateTime.now();

          List<Course> courses = querySnapshot.docs
              .map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                if (data['startTime']) {
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

      return courses;
    } catch (e) {
      logger.i(e);
      return [];
    }
  }
Future<List<Course>> fetchCoursesViaUser(String userId) async {
  try {
    DocumentReference userRef = _firestore.collection("users").doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    List<MyCourse>? myCourses =
        (userSnapshot.get("myCourses") as List<dynamic>?)
            ?.map((courseData) =>
                MyCourse.fromMap(courseData as Map<String, dynamic>))
            .toList();

    if (myCourses == null || myCourses.isEmpty) {
      return [];
    }

    List<Course> courses = await Future.wait(myCourses.map((myCourse) async {
      DocumentSnapshot courseSnapshot = await _firestore
          .collection("courses")
          .doc("kGrTotd8SFOUzsUH9Hpz")
          .collection(myCourse.course)
          .doc(myCourse.courseId)
          .get();
      Map<String, dynamic>? data =
          courseSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return Course.fromMap(data);
      } else {
        return Course(
            description: '',
            type: '',
            title: '',
            photo: '',
            lectures: '',
            teacher: '',
            lectureKey: '',
            courseKey: '');
      }
    }));

    print("Courses fetched successfully: $courses");
    return courses;
  } catch (e) {
    print("Error fetching courses: $e");
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
      logger.i("Error fetching videos: $e");
      return [];
    }
  }

  Future<List<Course>> fetchCollectionCourseData() async {
    try {
      final List<QuerySnapshot> snapshots = await Future.wait([
        _firestore
            .collection("courses")
            .doc("kGrTotd8SFOUzsUH9Hpz ")
            .collection("classBased")
            .get(),
        _firestore
            .collection("courses")
            .doc("kGrTotd8SFOUzsUH9Hpz ")
            .collection("skillBased")
            .get(),
        _firestore
            .collection("courses")
            .doc("kGrTotd8SFOUzsUH9Hpz ")
            .collection("humanRights")
            .get(),
      ]);

      final List<Course> courses = [];

      for (QuerySnapshot querySnapshot in snapshots) {
        courses.addAll(
          querySnapshot.docs
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
              .cast<Course>(),
        );
      }

      return courses;
    } catch (e) {
      logger.i(e);
      return [];
    }
  }
}
