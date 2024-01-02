

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  Future<List<Course>> fetchCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("courses").get();
      logger.i(querySnapshot);
      return querySnapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Course.fromMap(data);
      }).toList();
    } catch (e) {
      logger.i(e);
      return [];
    }
  }
}

class Course {
  final String type;
  final String title;
  final String photo;

  Course({
    required this.type,
    required this.title,
    required this.photo,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      type: map['type'],
      title: map['title'],
      photo: map['photo'],
    );
  }
}
