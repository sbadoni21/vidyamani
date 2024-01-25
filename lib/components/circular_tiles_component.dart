import 'package:flutter/material.dart';
import 'package:vidyamani/models/meeting_model.dart';
import 'package:vidyamani/services/data/datetimehelper_service.dart';
import 'package:vidyamani/utils/static.dart';

class CiruclarTiles extends StatelessWidget {
  final Meeting meeting;

  const CiruclarTiles({
    Key? key,
    required this.meeting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedMeetingTime =
        DateTimeHelper.formatMeetingTime(meeting.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Container(
            height: 120,
            width: 120,
            child: Image.asset(
              imageStatic,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          meeting.teacher,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: bgColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          formattedMeetingTime,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
