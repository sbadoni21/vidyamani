import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String imgUrl;
  final String text;
  final MaterialPageRoute pageRoute;

  const CategoryItem({
    Key? key,
    required this.imgUrl,
    required this.text,
    required this.pageRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(context, pageRoute);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Container(
            width: 50,
            height: 80,
            child: Image.asset(imgUrl, fit: BoxFit.contain),
          ),
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
