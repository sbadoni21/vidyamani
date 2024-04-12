class Carousal {
  final String photo;
  final String order;
  Carousal({required this.photo, required this.order});

  factory Carousal.fromMap(Map<String, dynamic> map) {
    return Carousal(photo: map['photo'], order: map['order']);
  }
}
