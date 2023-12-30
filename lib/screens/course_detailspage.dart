import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vidyamani/components/coursestopbar.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/utils/static.dart';

class CourseDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: bgColor, // Background color
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {},
        child: Text(
          "Buy Now",
        ),
      ),
      appBar: const CustomAppBarBckBtn(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: bgColor,
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.centerLeft,
                    child: Image.asset("lib/assets/images/featuredcourses.png"),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text("Introduction to UX Design",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF), // White color

                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "4 Lectures",
                              style: myTextStylefontsize10,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "2 live classes",
                              style: myTextStylefontsize10,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text("rating", style: myTextStylefontsize10)
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "₹ 1500",
                      style: TextStyle(
                          fontSize: 26,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                )
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
                Column(
                  children: [
                    CustomListTile(
                        imgUrl: "lib/assets/images/featuredcourses.png",
                        text1: "text1",
                        text2: "lorem ipsum",
                        onPressed: () {}),
                    CustomListTile(
                        imgUrl: "lib/assets/images/featuredcourses.png",
                        text1: "text1",
                        text2: "lorem ipsum",
                        onPressed: () {}),
                    CustomListTile(
                        imgUrl: "lib/assets/images/featuredcourses.png",
                        text1: "text1",
                        text2: "lorem ipsum",
                        onPressed: () {}),
                    CustomListTile(
                        imgUrl: "lib/assets/images/featuredcourses.png",
                        text1: "text1",
                        text2: "lorem ipsum",
                        onPressed: () {})
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
