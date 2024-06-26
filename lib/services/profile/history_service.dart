import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendHistoryVideos(String userId, Videos videos) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      List<dynamic> myHistory = (userSnapshot.data()
              as Map<String, dynamic>?)?['myHistory'] as List<dynamic>? ??
          [];

      bool videoExists = myHistory.any((element) {
        return element['lectureId'] == videos.lectureKey &&
            element['videoId'] == videos.videoUid;
      });

      if (!videoExists) {
        myHistory.add({
          'lectureId': videos.lectureKey,
          'videoId': videos.videoUid,
        });

        await userDocRef.update({
          'myHistory': myHistory,
        });

      } else {
      }
    // ignore: empty_catches
    } catch (e) {
      const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
    }
  }

  Future<List<Videos>> fetchSavedVideos(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection("users").doc(userId).get();

      List<History> myLectures =
          (userSnapshot.get("myHistory") as List<dynamic>?)
                  ?.map((courseData) =>
                      History.fromMap(courseData as Map<String, dynamic>))
                  .toList() ??
              [];

      List<Videos> myVideos = [];

      for (History myHistoryItem in myLectures) {
        DocumentSnapshot lectureSnapshot = await _firestore
            .collection("lectures")
            .doc(myHistoryItem.lectureId)
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
              .where((video) => video.videoUid == myHistoryItem.videoId)
              .toList();

          myVideos.addAll(selectedVideos);
        }
      }

      return myVideos;
    } catch (e) {
            const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      return [];
    }
  }
}
