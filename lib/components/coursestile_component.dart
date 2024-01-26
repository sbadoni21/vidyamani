import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/utils/static.dart';

class Tiles extends StatelessWidget {
  Course course;

  Tiles({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: course.photo.isNotEmpty
                      ? NetworkImage(course.photo)
                      : AssetImage('lib/assets/images/placeholder_image.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    course.type,
                    style: myTextStylefontsize14,
                  )),
            ),
          ],
        ),
        Container(
            height: 40,
            width: 120,
            child: Text(course.title,
                style: TextStyle(
                    fontSize: 14, color: bgColor, fontWeight: FontWeight.w600)))
      ],
    );
  }
}



//  Container(
//         height: 220, // Adjust the height as needed
//         width: 120,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               height: 120,
//               width: 120,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: imagePath.isNotEmpty
//                       ? NetworkImage(imagePath)
//                       : AssetImage('lib/assets/images/placeholder_image.png')
//                           as ImageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 6,
//               left: 6,
//               child: Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius:
//                       BorderRadius.vertical(bottom: Radius.circular(8)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         color: bgColor, // Background color
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text(
//                         text1,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               child: Container(
//                 height: 40,
//                 child: Text(
//                   text2,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),