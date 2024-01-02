import 'package:flutter/material.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:vidyamani/services/auth/signupservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidyamani/utils/static.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? user = await signup_service().registerUser(
        name: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        location: locationController.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {}

      // Clear form fields
      fullNameController.clear();
      locationController.clear();
      emailController.clear();
      passwordController.clear();
      retypePasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
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
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Signup",
                      style: TextStyle(
                          color: bgColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                      controller: fullNameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      icon: Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: locationController,
                      labelText: 'Location',
                      hintText: 'Enter your location',
                      icon: Icons.location_city),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      icon: Icons.email),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    icon: Icons.password,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: retypePasswordController,
                    labelText: 'Retype Password',
                    hintText: 'Retype your password',
                    icon: Icons.password,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: bgColor, // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 45.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      User? user =
                          await AuthenticationServices().signInWithGoogle();

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
                      "Signup using google",
                      style: TextStyle(color: bgColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
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
                        child: Text('Sign In')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue), // Customize outline color
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        } else if (labelText == 'Email' &&
            !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                .hasMatch(value)) {
          return 'Please enter a valid email address';
        } else if (labelText == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        } else if (labelText == 'Retype Password' &&
            value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}