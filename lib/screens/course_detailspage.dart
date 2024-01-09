import 'package:flutter/material.dart';
import 'package:vidyamani/components/coursestopbar.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/services/data/course_services.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/utils/static.dart';

class CourseDetailPage extends StatelessWidget {
  final Course courses;

  CourseDetailPage({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {},
        child: Text("Buy Now"),
      ),
      appBar: CustomAppBarBckBtn(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: bgColor,
            child: Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.centerLeft,
                    child: Image.network(courses.photo),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text(courses.title, style: myTextStylefontsize16white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${courses.lectures?.toString() ?? ""} Lectures',
                              style: myTextStylefontsize10,
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2),
                            Text(
                              "2 live classes",
                              style: myTextStylefontsize10,
                            ),
                            SizedBox(height: 2),
                            Text("rating", style: myTextStylefontsize10),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '₹ ${courses.price?.toString() ?? ""} ',
                      style: TextStyle(
                        fontSize: 26,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Course Content", style: myTextStylefontsize16),
                const SizedBox(height: 8),
                FutureBuilder<List<Videos>>(
                  future: DataService()
                      .fetchLecturesWithLectureKey(courses.lectureKey),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Videos> coursesWithLectureKey = snapshot.data ?? [];

                      return Column(
                        children: [
                        for (int index = 0; index < coursesWithLectureKey.length; index++)
  VideoTile(video: coursesWithLectureKey[index],   index: index, courseKey: courses.lectureKey ),

                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
