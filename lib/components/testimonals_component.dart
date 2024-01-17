import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vidyamani/models/testimonial_model.dart';
import 'package:vidyamani/utils/static.dart';

class TestimonialCard extends StatelessWidget {
  final Review testimonial;

   TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 180,
      width: screenWidth - 32,
      child: Card(
        color: const Color(0xFFF0F5FD),
        elevation: 0,
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(testimonial.profilephoto ?? ''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            const  SizedBox(
                width: 10,
              ),
              Container(
                width: 180,
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Text(
                        '""',
                        style: myTextStylefontsize24BGCOLOR,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: RatingBar.builder(
                        ignoreGestures: true,
                        initialRating:
                            double.tryParse(testimonial.rating) ?? 0.0,
                        minRating: 1,
                        itemCount: 5,
                        itemSize: 15.0,
                        itemBuilder: (context, _) =>const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 0,
                      child: Text(
                        testimonial.displayName,
                        style: myTextStylefontsize20BGCOLOR,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 0,
                      child: Container(
                        height: 50,
                        width: 250,
                        child: Text(
                          testimonial.comments,
                          style: myTextStylefontsize12BGCOLOR,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        '""',
                        style: myTextStylefontsize24BGCOLOR,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
