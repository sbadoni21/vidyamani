import 'package:flutter/material.dart';
import 'package:vidyamani/services/data/testimonals_service.dart';
import 'package:vidyamani/utils/static.dart';

class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF0F5FD),
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
                  image: NetworkImage(testimonial.profilephoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: bgColor,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  if (testimonial.reviews.isNotEmpty)
                    Text(
                      testimonial.reviews[0].comments,
                      style: TextStyle(fontSize: 12.0),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '"',
              style: TextStyle(
                color: bgColor,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example Usage:
// TestimonialCard(
//   testimonial: Testimonial(
//     name: 'John Doe',
//     course: 'Flutter Course',
//     email: 'john.doe@example.com',
//     profilephoto: 'assets/images/profile.jpg',
//     reviews: [{'comments': 'This is an amazing testimonial. I highly recommend!'}],
//   ),
// )
