import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/models/user_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  File? _userImage;

  final GlobalKey<FormState> _firstPageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondPageKey = GlobalKey<FormState>();
  int _currentPage = 1;
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _selectImage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() {
            _userImage = File(pickedFile.path);
          });
        }
      } else {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() {
            _userImage = File(pickedFile.path);
          });
        }
      }
    } else {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _userImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _submitFirstPage() async {
    if (_firstPageKey.currentState?.validate() ?? false) {
      if (_userImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
          ),
        );
      } else {
        setState(() {
          _currentPage = 2;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      isLoading = true;
    });
    if (_secondPageKey.currentState?.validate() ?? false) {
      User? user =
          await ref.read(userStateNotifierProvider.notifier).signInWithEmail(
                name: fullNameController.text,
                email: emailController.text,
                password: passwordController.text,
                location: locationController.text,
                userImage: _userImage,
              );

      if (user != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        SnackBar(
            content: Dialog(
          child: Text("Error has been encountered"),
        ));
      }

      fullNameController.clear();
      locationController.clear();
      emailController.clear();
      passwordController.clear();
      retypePasswordController.clear();
      _userImage = null;
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
              key: _currentPage == 1 ? _firstPageKey : _secondPageKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Container(
                  //   width: double.infinity,
                  //   child: Text(
                  //     _currentPage == 1 ? "Page - 1" : "Page - 2",
                  //     style: TextStyle(
                  //         color: bgColor,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                  SizedBox(
                    height: 16,
                  ),
                  _currentPage == 1
                      ? _buildFirstPageFields()
                      : _buildSecondPageFields(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        _currentPage == 1 ? _submitFirstPage : _submitForm,
                    child: isLoading == true
                        ? CircularProgressIndicator()
                        : Text(
                            _currentPage == 1 ? "Next" : "Submit",
                          ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: bgColor, // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(
                          horizontal: 45.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      User? user = await ref
                          .read(userStateNotifierProvider.notifier)
                          .signInWithGoogle();

                      if (user != null) {
                        setState(() {
                          isLoading = false;
                        });
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

  Widget _buildFirstPageFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField(
          controller: fullNameController,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildLocationDropdown(),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.blue,
              ),
            ),
            child: _userImage != null
                ? Image.file(
                    _userImage!,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.blue),
                      Text('Select Image'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPageFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField(
          controller: emailController,
          labelText: 'Email',
          hintText: 'Enter your email',
          icon: Icons.email,
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentPage = 1;
                });
              },
              child: const Text('Previous'),
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white, // Background color
                foregroundColor: bgColor, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      alignment: Alignment.centerLeft,
      style: myTextStylefontsize14,
      borderRadius: BorderRadius.circular(25),
      value: locationController.text.isNotEmpty
          ? locationController.text
          : 'Uttarakhand',
      onChanged: (String? newValue) {
        setState(() {
          locationController.text = newValue ?? 'Uttarakhand';
        });
      },
      items: [
        'Andhra Pradesh',
        'Arunachal Pradesh',
        'Assam',
        'Bihar',
        'Chhattisgarh',
        'Goa',
        'Gujarat',
        'Haryana',
        'Himachal Pradesh',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Madhya Pradesh',
        'Maharashtra',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Odisha',
        'Punjab',
        'Rajasthan',
        'Sikkim',
        'Tamil Nadu',
        'Telangana',
        'Tripura',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal',
        'Andaman and Nicobar',
        'Chandigarh',
        'Dadra and Nagar Haveli',
        'Daman and Diu'
            'Lakshadweep',
        'Delhi',
        'Puducherry',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Location',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.people, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select Location';
        }
        return null;
      },
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
        hintStyle: myTextStylefontsize14,
        labelStyle: myTextStylefontsize14,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
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
