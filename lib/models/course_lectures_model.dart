class Course {
  final String type;
  final String title;
  final String photo;
  final String? lectures;
  final String? description;
  final String? teacher;
  final String? lectureKey;
  final String? courseKey;
  final String? courseCollection;
  final String? startTime;
  Course(
      {required this.type,
      required this.title,
      required this.photo,
      required this.description,
      this.lectures,
      this.courseCollection,
      this.courseKey,
      this.teacher,
      this.lectureKey,
      this.startTime});

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        type: map['type'] ?? '',
        title: map['title'] ?? '',
        photo: map['photo'] ?? '',
        description: map['description'] ?? '',
        lectures: map['lectures'] ?? "",
        teacher: map['teacher'] ?? '',
        lectureKey: map['lectureKey'] ?? "",
        courseKey: map['uid'] ?? "",
        courseCollection: map['courseCollection'] ?? "",
        startTime: map['startTime'] ?? "");
  }
}

class Lectures {
  final String type;
  final String title;
  final String photo;
  final String? lectureKey;
  final List<Videos> videos;

  Lectures({
    required this.type,
    required this.title,
    required this.photo,
    required this.videos,
    this.lectureKey,
  });

  factory Lectures.fromMap(Map<String, dynamic> map) {
    return Lectures(
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      photo: map['photo'] ?? '',
      lectureKey: map['uid'] ?? '',
      videos: (map['video'] as List<dynamic>?)
              ?.map((video) => Videos.fromMap(video as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Videos {
  final String videoUrl;
  final List<Comments>? comments;
  final String? title;
  final String content;
  final String videoUid;
  final String lectureKey;
  Videos(
      {required this.videoUrl,
      this.comments,
      this.title,
      required this.content,
      required this.lectureKey,
      required this.videoUid});

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
        videoUrl: map['video'],
        comments: (map['comments'] as List<dynamic>?)
                ?.map((comment) =>
                    Comments.fromMap(comment as Map<String, dynamic>))
                .toList() ??
            [],
        lectureKey: map['lectureKey'],
        title: map['title'] ?? "",
        videoUid: map['videoUid'],
        content: map['content'] ?? "");
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
