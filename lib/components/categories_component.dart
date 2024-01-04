import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String imgUrl;
  final String text;

  const CategoryItem({
    Key? key,
    required this.imgUrl,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 80,
          child: Image.asset(imgUrl, fit: BoxFit.contain),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
