import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/sidemenu_assets.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/utils/static.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
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
                                backgroundImage: (profilePhoto != null ||
                                        profilePhoto == 'none')
                                    ? NetworkImage(profilePhoto!)
                                        as ImageProvider
                                    : const AssetImage(
                                        'lib/assets/images/placeholder_image.png'),
                                radius: 20,
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
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                      displayName != null
                                          ? displayName as String
                                          : "Username",
                                      style: myTextStylefontsize24),
                                ),
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
                              ref
                                  .read(userStateNotifierProvider.notifier)
                                  .signOut();
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
                                  asset['icon'],
                                  key: Key(
                                    asset['key'],
                                  ),
                                  color: bgColor,
                                ),
                              ),
                              Text(
                                asset['text'],
                                style: myTextStylefontsize16,
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
                  const Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "E-Learning Point Pvt. Ltd",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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
