import 'package:flutter/material.dart';
import 'package:vidyamani/components/customlongtile.dart';

class UpcomingPage extends StatefulWidget {
  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  // Add state variables or methods as needed

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CustomListTile(imgUrl: "lib/assets/images/skillbasedcourses.png", text1: "text1", text2: "lorem ipsum", onPressed: (){})
          ],
        ),
      ),
    );
  }
}
