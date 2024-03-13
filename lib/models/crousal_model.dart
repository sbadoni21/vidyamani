class Carousal {

  final String photo;

  Carousal(
      {      required this.photo,
     });

  factory Carousal.fromMap(Map<String, dynamic> map) {
    return Carousal(

        photo: map['photo'] ?? 'none',
    );
  }
}
