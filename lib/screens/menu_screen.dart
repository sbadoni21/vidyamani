import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/sidemenu_assets.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:vidyamani/utils/static.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? displayName;
  String? profilePhoto;

  @override
  void initState() {
    fetchDisplayName();
    super.initState();
  }

  void fetchDisplayName() async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid);

    userDoc.get().then((doc) {
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        setState(() {
          displayName = userData['displayName'];
          profilePhoto = userData['profilephoto'];
        });
      }
    }).catchError((error) {
      print('Error fetching display name: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBarBckBtn(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 250,
                            color: bgColor,
                            child: const Center(),
                          ),
                          // Circular Image (Upper)
                          Positioned(
                            left: 50,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: CircleAvatar(
                                backgroundImage: profilePhoto != null
                                    ? NetworkImage(profilePhoto!)
                                        as ImageProvider // Cast to ImageProvider
                                    : AssetImage(
                                        'lib/assets/images/placeholder_image.png'), // Use a placeholder image
                                radius: 20, // Adjust the size as needed
                              ),
                            ),
                          ),
                          Positioned(
                            left: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hi", style: myTextStylefontsize24),
                                Text(
                                    displayName != null
                                        ? displayName as String
                                        : "Username",
                                    style: myTextStylefontsize24),
                                Text(_firebaseAuth.currentUser!.email as String,
                                    style: myTextStylefontsize16white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: sideMenuItems.map((asset) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (asset['text'] == 'Logout') {
                              AuthenticationServices authService =
                                  AuthenticationServices();
                              await authService.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => asset['route'],
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 70,
                                child: Icon(
                                  asset[
                                      'icon'], // Use asset['icon'] to access the icon
                                  key: Key(
                                    asset['key'],
                                  ),
                                  color:
                                      bgColor, // Provide a unique key for the Icon
                                ),
                              ),
                              Text(
                                asset['text'],
                                style:
                                    myTextStylefontsize16, // Use asset['text'] for the text
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Add the "Made with Love" text at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Made with 🖤  ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
