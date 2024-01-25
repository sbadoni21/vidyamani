import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/models/meeting_model.dart';
import 'package:vidyamani/services/data/datetimehelper_service.dart';

class MeetingDetailPage extends StatelessWidget {
  final Meeting meeting;

  MeetingDetailPage({required this.meeting});

  @override
  Widget build(BuildContext context) {
    String formattedMeetingTime =
        DateTimeHelper.formatMeetingTime(meeting.startTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teacher: ${meeting.teacher}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Meeting ID: ${meeting.meetingID}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Meeting Passcode: ${meeting.meetingPasscode}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${formattedMeetingTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL(meeting.link),
              child: Text(
                'Link: ${meeting.link}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
