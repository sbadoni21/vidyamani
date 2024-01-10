import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
 import 'package:geocoding/geocoding.dart';

final authenticationServicesProvider = Provider<AuthenticationServices>((ref) {
  return AuthenticationServices();
});

class AuthenticationServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  Future<bool> sendOTP(String email) async {
    if (EmailValidator.validate(email)) {
      try {
        String otp = randomAlphaNumeric(6);
        // Implement OTP sending logic
        return true;
      } catch (e) {
        print('Failed to send OTP: $e');
        return false;
      }
    } else {
      print('Invalid email address');
      return false;
    }
  }

  Future<bool> validateOTP(String otpEntered, String otpSent) async {
    return otpEntered == otpSent;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Failed to reset password: $e');
      return false;
    }
  }


Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final email = userCredential.user!.providerData[0].email;
        final uid = userCredential.user!.uid;
        final displayName = userCredential.user!.displayName;
        final status = 'active';
        final photoURL = userCredential.user!.photoURL;
        final coins = 0;
        final referralCode = randomAlphaNumeric(8);

        _fireStore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'displayName': displayName,
          'status': status,
          'profilephoto': photoURL,
          'coins': coins,
          'referral': referralCode,
        });

        // Retrieve user's location
        Position? position = await Geolocator.getCurrentPosition();
        if (position != null) {
          // Reverse geocode to get city
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            String city = placemarks[0].locality ?? "Unknown City";
            // Include city data in Firestore or perform other actions
            _fireStore.collection('users').doc(uid).update({
              'location': city,
            });
          }
        }

        return userCredential.user;
      }
    }
  } catch (e) {
    print('Failed to sign in with Google: $e');
  }
  return null;
}


  Future<String?> getCurrentUserId() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        return user.uid;
      }
    } catch (e) {
      print('Failed to get current user ID: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
