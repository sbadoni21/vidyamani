import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class Tiles extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  final MaterialPageRoute pageRoute; // Added MaterialPageRoute input

  const Tiles({
    Key? key,
    required this.imagePath,
    required this.text1,
    required this.text2,
    required this.pageRoute, // Added this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, pageRoute); // Use the provided MaterialPageRoute
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 120,
            child:
                 imagePath.isNotEmpty
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.fill,
                      )
                :
                Image.asset(
              'lib/assets/images/placeholder_image.png', // Provide the path to your default image asset
              fit: BoxFit.cover,
              width: double.infinity,
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
