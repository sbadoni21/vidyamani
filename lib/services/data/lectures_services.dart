import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class LectureDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );

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
              // If any required field is empty, return null
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

class Lectures {
  final String type;
  final String title;
  final String photo;

  Lectures({
    required this.type,
    required this.title,
    required this.photo,
  });

  factory Lectures.fromMap(Map<String, dynamic> map) {
    return Lectures(
      type: map['type'],
      title: map['title'],
      photo: map['photo'],
    );
  }
}
