// category_model.dart

class Category {
  final String image;
  final String name;

  Category({
    required this.image,
    required this.name,
  });
}

// Sample data for 5 categories
List<Category> categoriesData = [
  Category(image: 'lib/assets/images/featuredcourses.png', name: 'Category 1'),
  Category(image: 'lib/assets/images/featuredcourses.png', name: 'Category 2'),
  Category(image: 'lib/assets/images/featuredcourses.png', name: 'Category 3'),
  Category(image: 'lib/assets/images/featuredcourses.png', name: 'Category 4'),
  Category(image: 'lib/assets/images/featuredcourses.png', name: 'Category 5'),
];
