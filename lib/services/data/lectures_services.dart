import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';

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
          const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
          return [];
        }
      } else {
        const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
        return [];
      }
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      return [];
    }
  }

  Future<String?> fetchLectureUidByIndex(String lectureKey, int index) async {
    try {
      DocumentSnapshot courseSnapshot =
          await _firestore.collection("lectures").doc(lectureKey).get();

      if (courseSnapshot.exists) {
        if (courseSnapshot['video'] is List) {
          List<Map<String, dynamic>> videos =
              List<Map<String, dynamic>>.from(courseSnapshot['video']);

          if (index >= 0 && index < videos.length) {
            String lectureUid = videos[index]['videoUid'] as String;
            return lectureUid;
          }
        }
      }
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );    }

    return null;
  }

  Future<List<Videos>> fetchSavedVideos(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection("users").doc(userId).get();

      List<SavedLecture> myLectures =
          (userSnapshot.get("savedLectures") as List<dynamic>?)
                  ?.map((courseData) =>
                      SavedLecture.fromMap(courseData as Map<String, dynamic>))
                  .toList() ??
              [];

      List<Videos> savedVideos = [];

      for (SavedLecture myLecture in myLectures) {
        DocumentSnapshot lectureSnapshot = await _firestore
            .collection("lectures")
            .doc(myLecture.lectureId)
            .get();
        Map<String, dynamic>? lectureData =
            lectureSnapshot.data() as Map<String, dynamic>?;

        if (lectureData != null) {
          List<Videos> videos = (lectureData['video'] as List<dynamic>?)
                  ?.map(
                      (video) => Videos.fromMap(video as Map<String, dynamic>))
                  .toList() ??
              [];

          List<Videos> selectedVideos = videos
              .where((video) => video.videoUid == myLecture.videoId)
              .toList();

          savedVideos.addAll(selectedVideos);
        }
      }

      return savedVideos;
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      return [];
    }
  }

  Future<List<Lectures>> fetchCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("lectures").get();
      return querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data != null ) {
              return Lectures.fromMap(data);
            } else {
              return null;
            }
          })
          .where((lecture) => lecture != null)
          .cast<Lectures>()
          .toList();
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      return [];
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
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      return 0;
    }
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  Future<void> updateOverallRating(
      String courseKey, double overallRating) async {
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
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      }
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );    }
  }

  Future<bool> isCourseSaved(String userId, String courseId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection("users").doc(userId).get();

      List<dynamic> myCourses =
          (userSnapshot.data() as Map<String, dynamic>?)?['myCourses'] ?? [];
      bool isSaved = myCourses.any((course) => course['courseKey'] == courseId);

      return isSaved;
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      return false;
    }
  }

  Future<void> saveCourse(String userId, Course course) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      List<dynamic> myCourses = (userSnapshot.data()
              as Map<String, dynamic>?)?['myCourses'] as List<dynamic>? ??
          [];
      print("gegasdd sada  asdf ${myCourses}");
      if (userSnapshot != null) {
        await userDocRef.update({
          'myCourses': FieldValue.arrayUnion([
            {
              'courseCollection': course.courseCollection,
              'courseKey': course.courseKey,
            },
          ]),
        });
      } else {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      }
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );    }
  }

  Future<void> unsaveCourse(String userId, Course course) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'myCourses': FieldValue.arrayRemove([
          {
            'courseCollection': course.courseCollection,
            'courseKey': course.courseKey,
          },
        ])
      });
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );    }
  }
}
