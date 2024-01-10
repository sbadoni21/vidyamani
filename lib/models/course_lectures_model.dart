class Course {
  final String type;
  final String title;
  final String photo;
  final String? lectures;
  final String? price;
  final String? teacher;
  final String lectureKey;
  final String? courseKey;

  Course({
    required this.type,
    required this.title,
    required this.photo,
    this.lectures,
    this.price,
    this.courseKey,
    required this.teacher,
    required this.lectureKey,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      photo: map['photo'] ?? '',
      lectures: map['lectures'] ?? "",
      price: map['price'] ?? "",
      teacher: map['teacher'] ?? '',
      lectureKey: map['lectureKey'] ?? "",
      courseKey: map['uid'] ?? "",
    );
  }
}

class Lectures {
  final String type;
  final String title;
  final String photo;
  final List<Videos> videos;

  Lectures({
    required this.type,
    required this.title,
    required this.photo,
    required this.videos,
  });

  factory Lectures.fromMap(Map<String, dynamic> map) {
    return Lectures(
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      photo: map['photo'] ?? '',
      videos: (map['videos'] as List<dynamic>?)
              ?.map((video) => Videos.fromMap(video as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Videos {
  final String videoUrl;
  final List<Comments> comments;
  final String title;
  final String content;
  Videos(
      {required this.videoUrl,
      required this.comments,
      required this.title,
      required this.content});

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
        videoUrl: map['video'],
        comments: (map['comment'] as List<dynamic>?)
                ?.map((comment) =>
                    Comments.fromMap(comment as Map<String, dynamic>))
                .toList() ??
            [],
        title: map['title'],
        content: map['content']);
  }
}

class Comments {
  final String rating;
  final String comment;
  final String userId;
  final String userName;
  Comments(
      {required this.rating,
      required this.comment,
      required this.userId,
      required this.userName});

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
        rating: map['rating'],
        comment: map['comment'],
        userId: map['userId'],
        userName: map['userName']);
  }
}
