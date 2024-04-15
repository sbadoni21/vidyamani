class Meeting {
  final String link;
  final String meetingID;
  final String meetingPasscode;
  final String teacher;
  final String uid;
  final String startTime;
  final String endTime;
  final String title;
  final String photo;
  final String description;
  final String type;
  Meeting(
      {required this.link,
      required this.meetingID,
      required this.meetingPasscode,
      required this.teacher,
      required this.startTime,
      required this.endTime,
      required this.title,
      required this.photo,
      required this.description,
      required this.type,
      required this.uid});

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
        type: map['type'],
        link: map['link'] ?? '',
        meetingID: map['meetingID'] ?? '',
        meetingPasscode: map['meetingPasscode'] ?? '',
        teacher: map['teacher'] ?? "",
        startTime: map['startTime'] ?? "",
        endTime: map['endTime'] ?? '',
        title: map['title'] ?? "",
        description: map['description'] ?? '',
        photo: map['photo'] ?? '',
        uid: map['uid'] ?? "");
  }
}
