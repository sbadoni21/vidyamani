import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/models/meeting_model.dart';
import 'package:riverpod/riverpod.dart';

final meetingServiceProvider = Provider<MeetingService>((ref) {
  return MeetingService();
});

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Meeting>> getMeetings() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('meeting').get();
      DateTime nowLocal = DateTime.now();
      List<Meeting> allMeetings = querySnapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => Meeting.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

 

      List<Meeting> filteredMeetings = allMeetings.where((meeting) {
        DateTime meetingEndTime = parseCustomDate(meeting.endTime);
        return meetingEndTime.isAfter(nowLocal);
      }).toList();
  

      return filteredMeetings;
    } catch (e) {
      const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
      throw Exception("Error fetching meetings: $e");
    }
  }

  DateTime parseCustomDate(String dateString) {
    try {
      if (dateString.isEmpty) {
        throw FormatException("Empty date string");
      }

      List<String> dateTimeParts = dateString.split('T');
      if (dateTimeParts.length == 2) {
        String datePart = dateTimeParts[0];
        String timePart = dateTimeParts[1];

        List<String> dateComponents = datePart.split('-');
        List<String> timeComponents = timePart.split(':');

        int year = int.parse(dateComponents[0]);
        int month = int.parse(dateComponents[1]);
        int day = int.parse(dateComponents[2]);
        int hour = int.parse(timeComponents[0]);
        int minute = int.parse(timeComponents[1]);

        DateTime localDateTime = DateTime(year, month, day, hour, minute);

        return localDateTime;
      } else {
        const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );
        throw FormatException("Invalid date format");
      }
    } catch (e) {
const  SnackBar(
        content: Text("Error encountered, please try again later"),
      );      throw Exception("Error parsing date: $e");
    }
  }
}
