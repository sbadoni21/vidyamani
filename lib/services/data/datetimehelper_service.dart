import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatMeetingTime(String meetingTime) {
    List<String> dateTimeParts = meetingTime.split('T');
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];

    List<String> dateParts = datePart.split('-');
    List<String> timeParts = timePart.split(':');

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    DateTime meetingDateTime = DateTime(year, month, day, hour, minute);
    DateTime now = DateTime.now();

    if (now.difference(meetingDateTime).inDays == 0) {
      if (now.isBefore(meetingDateTime)) {
        Duration remainingTime = meetingDateTime.difference(now);
        return '${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m left';
      } else if (now.difference(meetingDateTime).inMinutes <= 5) {
        return 'Live';
      }
    } else if (now.difference(meetingDateTime).inDays <= 7) {
      return '${DateFormat('EEEE').format(meetingDateTime)}, ${DateFormat.jm().format(meetingDateTime)}';
    } else {
      return '${DateFormat('dd/MM').format(meetingDateTime)}, ${DateFormat.jm().format(meetingDateTime)}';
    }

    return '';
  }
}
