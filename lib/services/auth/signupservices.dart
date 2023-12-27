
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidyamani/services/notification/notificationservices.dart';

class signup_service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,

    required String location,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save additional user data to Firestore
        final deviceToken = await NotificationService().getDeviceToken();
        await _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'displayName': name,
          'status': 'Online',
          'photoURL': "assets/image6.png",
          'deviceToken': deviceToken
        }, SetOptions(merge: true));

        return userCredential.user;
      }
    } catch (e) {
 return null;
    }
  }
}