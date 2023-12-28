import 'package:flutter/material.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:vidyamani/utils/static.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 230,
              width: 180,
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/images/logo.png",
                    fit: BoxFit.contain,
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
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Please enter your registered email',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: bgColor)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String newPassword = newPasswordController.text;

                if (newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter your registered email"),
                    ),
                  );
                } else {
                  bool passwordReset =
                      await AuthenticationServices().resetPassword(newPassword);

                  if (passwordReset) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset link sent via email'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Failed to reset the password. Please try again.'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor, // Button color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
