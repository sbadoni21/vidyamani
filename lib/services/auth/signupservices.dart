
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidyamani/services/notification/notificationservices.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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

        // Upload user image to Firebase Storage
        String? photoURL;
        if (userImage != null) {
          final Reference storageReference = _storage.ref().child(
              'user_images/${userCredential.user!.uid}/${DateTime.now().millisecondsSinceEpoch}.png');
          final UploadTask uploadTask = storageReference.putFile(userImage);
          await uploadTask.whenComplete(() async {
            photoURL = await storageReference.getDownloadURL();
          });
        }

        await _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'displayName': name,
          'status': 'Online',
          'photoURL': photoURL ?? "assets/image6.png",
          'deviceToken': deviceToken,
        }, SetOptions(merge: true));

        return userCredential.user;
      }
    } catch (e) {
      return null;
    }
  }
}
