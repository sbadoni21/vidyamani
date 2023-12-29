import 'package:flutter/material.dart';
import 'package:vidyamani/components/bottomnavbar_component.dart';
import 'package:vidyamani/components/dashboard_component.dart';
import 'package:vidyamani/services/profile/profile_services.dart';
import 'package:vidyamani/utils/static.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 3;
  final ProfileServices _profileServices = ProfileServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 16, right: 16),
            alignment: Alignment.bottomCenter,
            height: 180,
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "lib/assets/images/featuredcourses.png",
                          width: 120, // Adjust the width as needed
                          height: 120, // Adjust the height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_pin,
                                size: 16, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "location",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.published_with_changes,
                            color: Colors.white),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Change",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        Text(
                          "Password",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(children: [
              Dashboard(),
            ]),
          ),
        ],
      ),
    );
  }
}


// CircleAvatar(
//             radius: 50,
//             // backgroundImage: AssetImage('assets/placeholder_image.jpg'),
//           ),
//           SizedBox(height: 16),
//           Text('Name: $_name'),
//           ElevatedButton(
//             onPressed: () => _changeName(context),
//             child: Text('Change Name'),
//           ),
//           SizedBox(height: 16),
//           Text('Password: $_password'),
//           ElevatedButton(
//             onPressed: () => _changePassword(context),
//             child: Text('Change Password'),
//           ),
//           SizedBox(height: 16),
//           Text('Phone Number: $_phoneNumber'),
//           ElevatedButton(
//             onPressed: () => _changePhoneNumber(context),
//             child: Text('Change Phone Number'),
//           ),




  // Future<void> _fetchUserInfo() async {
  //   try {
  //     String userId = "uid";
  //     var userSnapshot = await _profileServices.getUserInfo(userId);

  //     if (userSnapshot.exists) {
  //       setState(() {
  //         _userID = userSnapshot.id;
  //         _name = userSnapshot.data()?['displayName'] ?? "N/A";
  //         _phoneNumber = userSnapshot.data()?['phoneNumber'] ?? "N/A";
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching user information: $e');
  //   }
  // }








  // Future<void> _changeName(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Change Name'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //             onChanged: (value) => _name = value,
  //             decoration: InputDecoration(labelText: 'Change Name'),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             if (_name.isNotEmpty) {
  //               await _profileServices.updateName(_userID, _name);
  //               print('Password changed successfully');
  //             } else {
  //               print('Invalid name input');
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _changePassword(BuildContext context) async {
  //   String oldPassword = "";
  //   String newPassword = "";

  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Change Password'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //             onChanged: (value) => oldPassword = value,
  //             obscureText: true,
  //             decoration: InputDecoration(labelText: 'Old Password'),
  //           ),
  //           SizedBox(height: 8),
  //           TextField(
  //             onChanged: (value) => newPassword = value,
  //             obscureText: true,
  //             decoration: InputDecoration(labelText: 'New Password'),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
  //               await _profileServices.updatePassword(_userID, newPassword);
  //               print('Password changed successfully');
  //             } else {
  //               print('Invalid password input');
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _changePhoneNumber(BuildContext context) async {
  //   String newPhoneNumber = "";

  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Change Phone Number'),
  //       content: TextField(
  //         onChanged: (value) => newPhoneNumber = value,
  //         decoration: InputDecoration(labelText: 'New Phone Number'),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             if (newPhoneNumber.isNotEmpty) {
  //               // Call your service to update the phone number
  //               await _profileServices.updatePhoneNumber(
  //                   _userID, newPhoneNumber);
  //               print('Phone number changed successfully');
  //             } else {
  //               print('Invalid phone number input');
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }