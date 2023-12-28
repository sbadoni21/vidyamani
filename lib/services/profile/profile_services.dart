// profile_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateName(String userId, String newName) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'name': newName});
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  Future<void> updatePassword(String userId, String newPassword) async {
    try {
      await _yourAuthUpdatePasswordMethod(newPassword);
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  Future<void> updatePhoneNumber(String userId, String newPhoneNumber) async {
    try {
      // Implement logic to update phone number in Firebase
    } catch (e) {
      print('Error updating phone number: $e');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> _yourAuthUpdatePasswordMethod(String newPassword) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
        print('Password updated successfully');
      } else {
        print('User not found. Please sign in again.');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }
}
