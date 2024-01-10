import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/course_lectures_model.dart';

class MiscellaneousService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addLectureToSaved(String userId, String courseId,
      String? videoId, BuildContext context) async {
    try {
      DocumentReference userDocRef = _fireStore.collection('users').doc(userId);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      List<dynamic> savedLectures = (userSnapshot.data()
              as Map<String, dynamic>?)?['savedLectures'] as List<dynamic>? ??
          [];

      bool lectureExists = savedLectures.any((lecture) {
        return lecture['courseId'] == courseId &&
            (videoId == null || lecture['videoId'] == videoId);
      });

      if (!lectureExists) {
        if (videoId != null) {
          await userDocRef.update({
            'savedLectures': FieldValue.arrayUnion([
              {'courseId': courseId, 'videoId': videoId}
            ]),
          });
          _showSnackbar(context, 'Lecture added to saved!');
        } else {
          await userDocRef.update({
            'savedLectures': FieldValue.arrayUnion([
              {'courseId': courseId}
            ]),
          });
          _showSnackbar(context, 'Lecture added to saved!');
        }
      } else {
        _showSnackbar(context, 'Lecture is already saved!');
      }
    } catch (e) {
      print('Failed to add lecture to saved: $e');
    }
  }

  Future<void> removeLectureFromSaved(String userId, String courseId,
      String? videoId, BuildContext context) async {
    try {
      DocumentReference userDocRef = _fireStore.collection('users').doc(userId);

      await userDocRef.update({
        'savedLectures': FieldValue.arrayRemove([
          {'courseId': courseId, 'videoId': videoId}
        ]),
      });

      _showSnackbar(context, 'Lecture removed from saved!');
    } catch (e) {
      print('Failed to remove lecture from saved: $e');
    }
  }

  Future<void> addAndListCommentToVideoLecture(String userId, String courseId,
      String? videoId, Comments newComment, BuildContext context) async {
    try {
      DocumentSnapshot courseSnapshot =
          await _fireStore.collection("lectures").doc(courseId).get();

      if (courseSnapshot.exists) {
        if (courseSnapshot['video'] is List) {
          List<Map<String, dynamic>> videos =
              List<Map<String, dynamic>>.from(courseSnapshot['video']);

          for (var video in videos) {
            if (video['videoUid'] == videoId) {
              List<Map<String, dynamic>> comments =
                  List<Map<String, dynamic>>.from(video['comments'] ?? []);

              // Add new comment
              String rating = newComment.rating?.isNotEmpty ?? false
                  ? newComment.rating!
                  : 'not rated';

              comments.add({
                'rating': rating,
                'comment': newComment.comment,
                'userId': newComment.userId,
                'userName': newComment.userName,
              });

              // Update the comments in the video field
              video['comments'] = comments;

              await _fireStore.collection("lectures").doc(courseId).update({
                'video': videos,
              });

              // Fetch and print all comments
              List<Comments> allComments =
                  comments.map((comment) => Comments.fromMap(comment)).toList();

              print('All Comments:');
              allComments.forEach((comment) {
                print(
                    'Rating: ${comment.rating}, Comment: ${comment.comment}, User: ${comment.userName}');
              });
            }
          }
        }
      }
    } catch (e) {
      print('Failed to add and list comments: $e');
    }
  }

  Future<List<Comments>> fetchAllComments(
      String? courseId, String? videoId) async {
    try {
      DocumentSnapshot courseSnapshot =
          await _fireStore.collection("lectures").doc(courseId).get();

      if (courseSnapshot.exists) {
        if (courseSnapshot['video'] is List) {
          List<Map<String, dynamic>> videos =
              List<Map<String, dynamic>>.from(courseSnapshot['video']);

          List<Comments> allComments = [];

          for (var video in videos) {
            // Check if the videoId matches the provided videoId
            if (video['videoUid'] == videoId) {
              List<Map<String, dynamic>> comments =
                  List<Map<String, dynamic>>.from(video['comments'] ?? []);

              List<Comments> videoComments =
                  comments.map((comment) => Comments.fromMap(comment)).toList();

              allComments.addAll(videoComments);
              break; 
            }
          }

          return allComments;
        }
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    }

    return [];
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
