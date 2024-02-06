import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/password_reset_page.dart';
import 'package:vidyamani/screens/signupscreen.dart';
import 'package:vidyamani/utils/static.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 150, 16, 16),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/images/logo.png",
                    fit: BoxFit.contain,
                    height: 230,
                    width: 180,
                  ),
                  Center(
                      child: Text(
                    "Vidhyamani",
                    style: TextStyle(
                      color: bgColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: bgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: bgColor),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: bgColor),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  ),
                ),
           const     SizedBox(
                  height: 10,
                ),
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
                  child: const SizedBox(
                    width: double.infinity,
                    child:  Text(
                      'Forgot password',
                      textAlign: TextAlign.right,
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      User? user = await ref
                          .read(userStateNotifierProvider.notifier)
                          .signIn(email, password);

                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                        print('Login successful');
                      } else {
                        print('Login failed');
                      }
                    } else {
                      print('Please enter email and password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: bgColor, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding:
                        EdgeInsets.symmetric(horizontal: 45.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    User? user = await ref
                        .read(userStateNotifierProvider.notifier)
                        .signInWithGoogle();
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      print('Login with Google successful');
                    } else {
                      print('Login with Google failed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: bgColor,
                    elevation: 5.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "lib/assets/images/google.png",
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Text(
                    "login using google",
                    style: TextStyle(color: bgColor),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: Colors.white, // Text color
                    side: BorderSide(color: bgColor), // Border color
                  ),
                  child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Text('Sign Up')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
