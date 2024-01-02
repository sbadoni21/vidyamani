import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/sidemenu_assets.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

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
          profilePhoto = userData['profilePhoto'];
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
                          // Adjust the margin to position it as needed
                          width: double.infinity,
                          height: 250,

                          color: Colors.white,
                          child: const Center(
                            child: Icon(
                              Icons.work,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
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
                                Text(
                                  "Hi",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  displayName != null
                                      ? displayName as String
                                      : "Username",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 15, 33, 47),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  _firebaseAuth.currentUser!.email as String,
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            )),
                        // Rectangular Image (Lower)
                      ],
                    ),
                  ),
                ),
                Column(
                  children: sideMenuItems.map((asset) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Colors.white),
                        onPressed: () async {
                          if (asset['text'] == 'Logout') {
                            AuthenticationServices authService =
                                AuthenticationServices();
                            await authService.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => asset['route']));
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 60,
                              child: Icon(
                                asset[
                                    'icon'], // Use asset['icon'] to access the icon
                                key: Key(
                                  asset['key'],
                                ),
                                color: Colors
                                    .blue, // Provide a unique key for the Icon
                              ),
                            ),
                            Text(
                              asset['text'],
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ), // Use asset['text'] for the text
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                            // Handle notifications icon press
                          },
                          icon: const Icon(Icons.arrow_back_sharp),
                          label: const Text("Back to Home")),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
