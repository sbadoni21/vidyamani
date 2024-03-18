import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';

class AllCoursesDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Course>> fetchCoursesFromCollection(String collectionName,
      {String? filterType}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('courses')
          .doc('kGrTotd8SFOUzsUH9Hpz')
          .collection('$collectionName')
          .get();
      List<Course> courses = [];
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data != null) {
          courses.add(Course.fromMap(data));
        }
      });
      return courses;
    } catch (error) {
     const SnackBar(content: Text("Error getting Collection Data"));
      throw error;
    }
  }
}

