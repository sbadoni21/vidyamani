import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/utils/static.dart';
class VideoTile extends StatelessWidget {
  final String title;
  final String videoUrl;

  VideoTile({required this.title, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      },
    );
  }
}
