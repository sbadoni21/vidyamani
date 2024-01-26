import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/testimonial_model.dart';

class TestimonialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Review>> fetchCollectionData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('testimonials').doc('testimonials').get();

      if (!snapshot.exists) {
        return [];
      }

      List<Review> testimonials = (snapshot.data()?['reviews'] as List<dynamic>)
          .map((review) => Review.fromMap(review))
          .toList();

      return testimonials;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addTestimonial(
    rating,
    comment,
    lectureKey,
    courseKey,
    profilephoto,
    userId,
    displayName,
  ) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('testimonials').doc('testimonials');

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(docRef);

        List<dynamic> existingReviews = snapshot.data()?['reviews'] ?? [];

        existingReviews.add({
          'ratings': rating,
          'comments': comment,
          'lectureKey': lectureKey,
          'courseKey': courseKey,
          'profilephoto': profilephoto,
          'userId': userId,
          'displayName': displayName,
        });

        transaction.update(docRef, {'reviews': existingReviews});
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
