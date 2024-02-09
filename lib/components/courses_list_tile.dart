import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/utils/static.dart';

class VideoSearchTile extends StatelessWidget {
  final Videos video;

  const VideoSearchTile({
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    String content = video.content.trim() ?? "";
    List<String> words = content.split(' ');

    String firstFourWords = words.length >= 4
        ? '${words[0]} ${words[1]} ${words[2]} ${words[3]}'
        : content;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title ?? "",
            style: myTextStylefontsize16,
          ),
          Text(
            firstFourWords,
            style: myTextStylefontsize12Black,
          ),
        ],
      ),
    );
  }
}
