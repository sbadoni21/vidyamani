import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class Testimonials extends StatelessWidget {
  final String imagePath;
  final String name;
  final String testimonial;

  const Testimonials({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.testimonial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      '"',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(color: bgColor, fontSize: 30, height: -1),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: bgColor),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    testimonial,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      '"',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: bgColor,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example Usage:
// Testimonials(
//   imagePath: 'assets/images/profile.jpg',
//   name: 'John Doe',
//   testimonial: 'This is an amazing testimonial. I highly recommend!',
// )
