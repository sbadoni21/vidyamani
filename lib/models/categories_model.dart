class Category {
  final String image;
  final String collectionName;
  final String headingName;

  Category(
      {required this.image,
      required this.collectionName,
      required this.headingName});
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      image: map['iconphoto'] ?? "",
      collectionName: map['collectionName'] ?? "",
      headingName: map['headingName'] ?? '',
    );
  }
}
