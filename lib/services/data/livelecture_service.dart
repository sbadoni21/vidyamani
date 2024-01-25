import 'package:cloud_firestore/cloud_firestore.dart';
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

      return querySnapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => Meeting.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching meetings: $e");
    }
  }
}
