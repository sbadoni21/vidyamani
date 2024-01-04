import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class CourseTile extends StatelessWidget {
  final String title;
  final String type; // Assuming 'type' is a property of AllCourseData
  // You can add more properties as needed

  const CourseTile({
    required this.title,
    required this.type,
    // Add more properties as needed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: cardColor,
      shape: BeveledRectangleBorder(
        side: BorderSide(
          style: BorderStyle.none,
          color: bgColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: myTextStylefontsize16,
                  ),
                  Text(
                    type, // Display the 'type' property
                    style: TextStyle(fontSize: 12),
                  ),
                  // Add more Text widgets for additional properties
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
