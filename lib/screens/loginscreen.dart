import 'package:flutter/material.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/password_reset_page.dart';
import 'package:vidyamani/screens/signupscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthenticationServices authenticationService = AuthenticationServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(
              "lib/assets/images/logo.jpg",
              height: 500,
              width: 500,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                    ),
                    child: const Text('Forgot password'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  User? user =
                      await authenticationService.signIn(email, password);

                  if (user != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                    print('Login successful');
                  } else {
                    print('Login failed');
                  }
                } else {
                  print('Please enter email and password');
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Implement navigation to the password reset page
                print('Navigate to password reset page');
              },
              child: Text('Forgot Password?'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                User? user = await authenticationService.signInWithGoogle();

                if (user != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                  print('Login with Google successful');
                } else {
                  // Handle login failure
                  print('Login with Google failed');
                }
              },
              child: Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
