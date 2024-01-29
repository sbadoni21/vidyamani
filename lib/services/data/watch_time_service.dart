import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WatchTimeService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<Map<String, dynamic>>> getWatchTimes(String userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? watchTimesJson = prefs.getString('$userId:watchTimes');

      if (watchTimesJson != null) {
        final List<Map<String, dynamic>> watchTimes =
            List<Map<String, dynamic>>.from(json.decode(watchTimesJson));
        return watchTimes;
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading watch times: $e');
      return [];
    }
  }

  Future<void> updateWatchTime(
      String userId, String videoId, String lectureKey) async {
    try {
      final List<Map<String, dynamic>> watchTimes = await getWatchTimes(userId);

      final existingIndex = watchTimes.indexWhere((entry) =>
          entry['videoId'] == videoId && entry['lectureKey'] == lectureKey);

      if (existingIndex != -1) {
        watchTimes[existingIndex]['watchTime'] += 1;
      } else {
        watchTimes.add({
          'videoId': videoId,
          'lectureKey': lectureKey,
          'watchTime': 1,
        });
      }

      await _updateLocalState(userId, watchTimes);
      await _updateBackend(userId, watchTimes);
    } catch (e) {
      print('Error updating watch time: $e');
    }
  }

  Future<void> updateWatchTimeLocally(String userId, String videoId,
      String lectureKey, List<Map<String, dynamic>> watchTimes) async {
    try {
      final existingIndex = watchTimes.indexWhere((entry) =>
          entry['videoId'] == videoId && entry['lectureKey'] == lectureKey);

      if (existingIndex != -1) {
        watchTimes[existingIndex]['watchTime'] += 1;
      } else {
        watchTimes.add({
          'videoId': videoId,
          'lectureKey': lectureKey,
          'watchTime': 1,
        });
      }

      await _updateLocalState(userId, watchTimes);
    } catch (e) {
      print('Error updating watch time locally: $e');
    }
  }

  Future<void> _updateLocalState(
      String userId, List<Map<String, dynamic>> watchTimes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('$userId:watchTimes', json.encode(watchTimes));
    } catch (e) {
      print('Error updating local state: $e');
    }
  }

  Future<void> _updateBackend(
      String userId, List<Map<String, dynamic>> watchTimes) async {
    try {
      await _usersCollection.doc(userId).update({'watchTimes': watchTimes});
    } catch (e) {
      print('Error updating backend: $e');
    }
  }
}
