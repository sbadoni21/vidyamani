class Carousal {
  final String courseCollection;
  final String courseKey;
  final String photo;

  Carousal(
      {required this.courseCollection,
      required this.courseKey,
      required this.photo,
     });

  factory Carousal.fromMap(Map<String, dynamic> map) {
    return Carousal(
        courseCollection: map['courseCollection'] ?? "",
        courseKey: map['courseKey'] ?? 0,
        photo: map['photo'] ?? 'none',
    );
  }
}
