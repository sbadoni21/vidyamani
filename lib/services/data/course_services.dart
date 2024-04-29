import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/crousal_model.dart';
import 'package:vidyamani/models/user_model.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );

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
      const SnackBar(content: Text("Error getting Upcoming Data"));
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
      const SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      return [];
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
      const SnackBar(
        content: Text("Error encountered, please try again later"),
      );
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
          const SnackBar(
            content: Text("Error encountered, please try again later"),
          );
          return [];
        }
      }

      return courses;
    } catch (e) {
      const SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      return [];
    }
  }

  Future<List<Course?>> fetchCoursesViaUser(String userId) async {
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

      List<Course?> courses = await Future.wait(myCourses.map((myCourse) async {
        DocumentSnapshot courseSnapshot = await _firestore
            .collection("courses")
            .doc("kGrTotd8SFOUzsUH9Hpz")
            .collection(myCourse.course)
            .doc(myCourse.courseId)
            .get();

        if (courseSnapshot.exists) {
          Map<String, dynamic>? data =
              courseSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            return Course.fromMap(data);
          }
        }

        return null;
      }));

      const SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      return courses;
    } catch (e) {
      const SnackBar(
        content: Text("Error encountered, please try again later"),
      ); // Log or handle the error as needed
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
          logger.i("Video data2: $data");
          return videos;
        } else {
          print("Error encountered, please try again later");
          return [];
        }
      } else {
        print("Error encountered, please try again later");
        return [];
      }
    } catch (e) {
      const SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      return [];
    }
  }
}
