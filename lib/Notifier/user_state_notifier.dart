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

  // Initialize user data when the notifier is created
  Future<void> _initUser() async {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        state = User.fromMap(snapshot.data()!);
      } else {
        // Handle the case when the user document doesn't exist
        state = null;
      }
    } catch (e) {
      // Handle exceptions
      state = null;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(User updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.uid)
          .set(updatedUser.toMap(), SetOptions(merge: true));

      // Update local state after successful Firestore update
      state = updatedUser;
    } catch (e) {
      // Handle exceptions
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

// Add more functions as needed for other user-related operations
}

// Define the provider for the UserStateNotifier
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User?>(
  (ref) => UserStateNotifier(ref),
);

// Extend the User model to include a method to convert to Map for Firestore
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
      'myCourses': myCourses.map((course) => course.toMap()).toList(),
      'savedLectures': savedLectures.map((lecture) => lecture.toMap()).toList(),
    };
  }
}

// Add toMap() method to MyCourse and SavedLecture classes
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
      'courseId': courseId,
      'videoId': videoId,
    };
  }
}
