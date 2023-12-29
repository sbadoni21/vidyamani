import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class CiruclarTiles extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  final MaterialPageRoute pageRoute; 

  const CiruclarTiles({
    Key? key,
    required this.imagePath,
    required this.text1,
    required this.text2,
    required this.pageRoute, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, pageRoute);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              height: 120,
              width: 120,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            text1,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: bgColor),
          ),
          SizedBox(height: 4),
          Text(
            text2,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
