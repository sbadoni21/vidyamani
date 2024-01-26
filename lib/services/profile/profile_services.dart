// profile_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileServices {
    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 Future<void> validateOldPassword(String userId, String oldPassword, String email) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );      if (userCredential.user?.uid != userId) {
        throw Exception('Invalid user credentials');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error validating old password: $e');
    }
  }
  Future<void> updatePassword(String userId, String newPassword) async {
    try {
      await _yourAuthUpdatePasswordMethod(newPassword);
    } catch (e) {
      print('Error updating password: $e');
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
