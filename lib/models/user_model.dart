class User {
  final String deviceToken;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoURL;
  final String referralCode;
  final String status;
  final String type;
  final String uid;
  final String? location;
  final List<MyCourse> myCourses;
  final List<History>? myHistory;
  final List<SavedLecture> savedLectures;

  User({
    required this.deviceToken,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.referralCode,
    required this.status,
    required this.type,
    required this.uid,
    this.location,
    this.myHistory,
    required this.myCourses,
    required this.savedLectures,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      deviceToken: map['deviceToken'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['profilephoto'] ?? '',
      referralCode: map['referralCode'] ?? '',
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      uid: map['uid'] ?? '',
      location: map['location'] ?? '',
      myCourses: (map['myCourses'] as List<dynamic>?)
              ?.map((e) => MyCourse.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      savedLectures: (map['savedLectures'] as List<dynamic>?)
              ?.map((e) => SavedLecture.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      myHistory: (map['myHistory'] as List<dynamic>?)
              ?.map((e) => History.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MyCourse {
  final String course;
  final String courseId;

  MyCourse({required this.course, required this.courseId});

  factory MyCourse.fromMap(Map<String, dynamic> map) {
    return MyCourse(
      course: map['courseCollection'] ?? '',
      courseId: map['courseKey'] ?? '',
    );
  }
}

class SavedLecture {
  final String lectureId;
  final String videoId;

  SavedLecture({required this.lectureId, required this.videoId});

  factory SavedLecture.fromMap(Map<String, dynamic> map) {
    return SavedLecture(
      lectureId: map['courseId'] ?? '',
      videoId: map['videoId'] ?? '',
    );
  }
}

class History {
  final String lectureId;
  final String videoId;

  History({required this.lectureId, required this.videoId});

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      lectureId: map['lectureId'] ?? '',
      videoId: map['videoId'] ?? '',
    );
  }
}
