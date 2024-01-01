import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String text;
  final Timestamp timestamp;

  const NoteCard({
    required this.title,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);

    String formattedDateTime;

    if (difference.inDays == 0) {
      formattedDateTime = '${dateTime.hour}:${dateTime.minute}';
    } else if (difference.inDays == 1) {
      formattedDateTime = 'Yesterday';
    } else if (difference.inDays < 7) {
      formattedDateTime = DateFormat('EEEE').format(dateTime);
    } else if (difference.inDays < 30) {
      formattedDateTime = DateFormat('MMMM').format(dateTime);
    } else {
      formattedDateTime = 'Long time ago';
    }

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
        height: 60,
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
                ],
              ),
              Text(
                formattedDateTime,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
