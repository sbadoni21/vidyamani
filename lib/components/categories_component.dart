import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

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
          width: 60,
          height: 60,
          child: Image.network(imgUrl, fit: BoxFit.fill),
        ),
        SizedBox(height: 8),
        Container(
            width: 60,
            child: Text(
              text,
              style: myTextStylefontsize10BGCOLOR,
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
}
