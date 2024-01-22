import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/models/user_model.dart';

import '../services/auth/authentication.dart';

final authenticationServicesProvider = Provider<AuthenticationServices>((ref) {
  return AuthenticationServices();
});

class UserStateNotifier extends StateNotifier<User?> {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserStateNotifier(this.ref) : super(null) {
    _initUser();
  }
  Future<void> _initUser() async {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        state = User.fromMap(snapshot.data()!);
      } else {
        state = null;
      }
    } catch (e) {
      // Handle exceptions
      state = null;
    }
  }

  Future<void> updateUserData(User updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.uid)
          .set(updatedUser.toMap(), SetOptions(merge: true));

      state = updatedUser;
    } catch (e) {
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      var firebaseUser = await ref
          .read(authenticationServicesProvider)
          .signIn(email, password);
      if (firebaseUser != null) {
        await fetchUserData(firebaseUser.uid);
      } else {
        state = null;
      }
    } catch (e) {
      state = null; // Handle exceptions
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(authenticationServicesProvider).signOut();
      state = null;
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      var firebaseUser =
          await ref.read(authenticationServicesProvider).signInWithGoogle();
      if (firebaseUser != null) {
        await fetchUserData(firebaseUser.uid);
      } else {
        state = null;
      }
    } catch (e) {
      state = null; // Handle exceptions
    }
  }

}
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User?>(
  (ref) => UserStateNotifier(ref),
);
extension on User {
  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'referralCode': referralCode,
      'status': status,
      'type': type,
      'uid': uid,
      'location': location,
      'myHistory': myCourses.map((lecture) => lecture.toMap()).toList(),
      'myCourses': myCourses.map((course) => course.toMap()).toList(),
      'savedLectures': savedLectures.map((lecture) => lecture.toMap()).toList(),
    };
  }
}

extension on MyCourse {
  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'courseId': courseId,
    };
  }
}

extension on SavedLecture {
  Map<String, dynamic> toMap() {
    return {
      'courseId': lectureId,
      'videoId': videoId,
    };
  }
}
extension on History {
  Map<String, dynamic> toMap() {
    return {
      'courseId': lectureId,
      'videoId': videoId,
    };
  }
}
