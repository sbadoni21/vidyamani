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
    required this.myCourses,
    required this.savedLectures,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      deviceToken: map['deviceToken'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
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
    );
  }
}

class MyCourse {
  final String course;
  final String courseId;

  MyCourse({required this.course, required this.courseId});

  factory MyCourse.fromMap(Map<String, dynamic> map) {
    return MyCourse(
      course: map['course'] ?? '',
      courseId: map['courseId'] ?? '',
    );
  }
}

class SavedLecture {
  final String courseId;
  final String videoId;

  SavedLecture({required this.courseId, required this.videoId});

  factory SavedLecture.fromMap(Map<String, dynamic> map) {
    return SavedLecture(
      courseId: map['courseId'] ?? '',
      videoId: map['videoId'] ?? '',
    );
  }
}
