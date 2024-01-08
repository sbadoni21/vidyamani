class Course {
  final String type;
  final String title;
  final String photo;
  final String? lectures;
  final String? price;
  final String? teacher;
  final String lectureKey;

  Course({
    required this.type,
    required this.title,
    required this.photo,
    this.lectures,
    this.price,
    required this.teacher,
    required this.lectureKey,
  });

  factory Course.fromMap(Map map) {
    return Course(
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      photo: map['photo'] ?? '',
      lectures: map['lectures'] ?? "",
      price: map['price'] ?? "",
      teacher: map['teacher'] ?? '',
      lectureKey: map['lectureKey'] ?? "",
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
          .toList() ?? [],
    );
  }
}


class Videos {
  final String videoUrl;
  final String comments;
  final String title;
  Videos({
    required this.videoUrl,
    required this.comments,
    required this.title
  });

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
      videoUrl: map['videoUrl'],
      comments: map['comments'],
      title:  map['title']
    );
  }
}

// class Lectures {
//   final String type;
//   final String title;
//   final String photo;

//   Lectures({
//     required this.type,
//     required this.title,
//     required this.photo,
//   });

//   factory Lectures.fromMap(Map<String, dynamic> map) {
//     return Lectures(
//       type: map['type'] ?? '',
//       title: map['title'] ?? '',
//       photo: map['photo'] ?? '',
//     );
//   }
// }
