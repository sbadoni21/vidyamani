import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/models/meeting_model.dart';
import 'package:vidyamani/services/data/datetimehelper_service.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:flutter/services.dart';

class MeetingDetailPage extends StatelessWidget {
  final Meeting meeting;

  MeetingDetailPage({required this.meeting});

  @override
  Widget build(BuildContext context) {
    String formattedMeetingTimeStart =
        DateTimeHelper.formatMeetingTime(meeting.startTime);
    String formattedMeetingTimeEnd =
        DateTimeHelper.formatMeetingTime(meeting.endTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.network(
                meeting.photo,
                width: double.infinity,
                height: 242,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${meeting.title}',
                  style: myTextStylefontsize20BGCOLOR,
                ),
                const SizedBox(height: 8),
                Text(
                  ' ${meeting.teacher}',
                  style: myTextStylefontsize20BGCOLOR,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ExpandableText(
              meeting.description,
              expandText: "..show more",
              maxLines: 3,
              animation: true,
              animationDuration: const Duration(seconds: 1),
              animationCurve: Curves.easeIn,
              collapseOnTextTap: true,
              linkColor: bgColor,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity - 40,
              child: Text(
                '${formattedMeetingTimeStart} - ${formattedMeetingTimeEnd}  ',
                style: myTextStylefontsize16,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Meeting Credentials',
                style: myTextStylefontsize16,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Meeting Id",
                    style: myTextStylefontsize16,
                  ),
                  Row(
                    children: [
                      Text('${meeting.meetingID}',
                          style: myTextStylefontsize16),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          _copyToClipboard(meeting.meetingID, context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password",
                    style: myTextStylefontsize16,
                  ),
                  Row(
                    children: [
                      Text('${meeting.meetingPasscode}',
                          style: myTextStylefontsize16),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          _copyToClipboard(meeting.meetingID, context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () => _launchURL(meeting.link),
                    child: Text("Join Now", style: myTextStylefontsize14White),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(
      text: text,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meeting ID copied to clipboard'),
      ),
    );
  }
}
