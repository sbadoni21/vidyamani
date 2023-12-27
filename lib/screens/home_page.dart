
import 'package:flutter/material.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await AuthenticationServices().signOut;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("logout"));
  }
}
