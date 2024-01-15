class Testimonial {
  final List<Review> reviews;
  final String uid;
  Testimonial({
    required this.uid,
    required this.reviews,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      uid: map['uid'],
      reviews: (map['reviews'] as List<dynamic>)
          .map((review) => Review.fromMap(review))
          .toList(),
    );
  }
}

class Review {
  final String rating;
  final String comments;
  final String lectureKey;
  final String courseKey;
  final String? profilephoto;
  final String userId;
  final String displayName;

  Review({
    required this.rating,
    required this.comments,
    required this.lectureKey,
    required this.courseKey,
    this.profilephoto,
    required this.userId,
    required this.displayName,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      rating: map['ratings'],
      comments: map['comments'],
      lectureKey: map['lectureKey'],
      courseKey: map['courseKey'],
      profilephoto: map['profilephoto'],
      userId: map['userId'],
      displayName: map['displayName'],
    );
  }
}
