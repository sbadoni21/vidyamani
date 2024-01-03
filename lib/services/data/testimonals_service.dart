import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class TestimonialDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<List<Testimonial>> fetchCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("testimonials").get();
      logger.i(querySnapshot);

      return querySnapshot.docs
          .map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data['displayName'] != null &&
     
                data['email'] != null &&
                data['profilephoto'] != null &&
                data['reviews'] != null) {
              return Testimonial.fromMap(data);
            } else {
              return null;
            }
          })
          .where((testimonial) => testimonial != null)
          .cast<Testimonial>()
          .toList();
    } catch (e) {
      logger.i(e);
      return [];
    }
  }
}

class Testimonial {
  final String name;

  final String email;
  final String profilephoto;
  final List<Review> reviews;

  Testimonial({
    required this.name,

    required this.email,
    required this.profilephoto,
    required this.reviews,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      name: map['displayName'],

      email: map['email'],
      profilephoto: map["profilephoto"],
      reviews: (map['reviews'] as List<dynamic>)
          .map((review) => Review.fromMap(review))
          .toList(),
    );
  }
}

class Review {
  final String rating;
  final String comments;

  Review({
    required this.rating,
    required this.comments,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      rating: map['ratings'],
      comments: map['comments'],
    );
  }
}
