import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:vidyamani/services/notification/notificationservices.dart';

class signup_service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
    required String location,
    File? userImage,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final deviceToken = await NotificationService().getDeviceToken();
        String? photoURL;
        if (userImage != null) {
          final Reference storageReference = _storage.ref().child(
              'user_images/${userCredential.user!.uid}/${DateTime.now().millisecondsSinceEpoch}.png');
          final UploadTask uploadTask = storageReference.putFile(userImage);
          await uploadTask.whenComplete(() async {
            photoURL = await storageReference.getDownloadURL();
          });
        }
        final referralCode = randomAlphaNumeric(8);
        const coins = 0;
        final List myCourses = [];
        await _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'role': "user",
          'displayName': name,
          "myCourses": myCourses,
          'status': 'Online',
          'profilephoto': photoURL ?? "none",
          'deviceToken': deviceToken,
          'type': "free",
          'location': location,
          'isGoogleUser': false,
          'referralCode': referralCode,
          'coins': coins,
          'subscriptionStart': '01-01-1901T01:00',
          'subscriptionEnd': '01-01-2099T01:00',
        }, SetOptions(merge: true));

        return userCredential.user;
      }
    } catch (e) {
      return null;
    }
  }
}
