// category_model.dart

class Category {
  final String image;
  final String name;

  Category({
    required this.image,
    required this.name,
  });
}

List<Category> categoriesData = [
  Category(
      image: 'lib/assets/images/skillBasedCourse.png',
      name: 'Skill Based Courses'),
  Category(image: 'lib/assets/images/audioBooks.png', name: 'Audiobooks'),
  Category(
      image: 'lib/assets/images/classBasedCourse.png',
      name: 'Class Based Course'),
  Category(image: 'lib/assets/images/humanRights.png', name: 'Human Rights'),
  Category(image: 'lib/assets/images/shorts.png', name: 'Shorts'),
];
