import 'package:flutter/material.dart';
import 'package:vidyamani/services/profile/profile_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileServices _profileServices = ProfileServices();
  String _name = "Loading...";
  String _password =
      "********"; // You might want to retrieve the password securely; this is just a placeholder
  String _phoneNumber = "Loading...";
  String _userID = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      String userId = "uid";
      var userSnapshot = await _profileServices.getUserInfo(userId);

      if (userSnapshot.exists) {
        setState(() {
          _userID = userSnapshot.id;
          _name = userSnapshot.data()?['displayName'] ?? "N/A";
          _phoneNumber = userSnapshot.data()?['phoneNumber'] ?? "N/A";
          

        });
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage('assets/placeholder_image.jpg'),
            ),
            SizedBox(height: 16),
            Text('Name: $_name'),
            ElevatedButton(
              onPressed: () => _changeName(context),
              child: Text('Change Name'),
            ),
            SizedBox(height: 16),
            Text('Password: $_password'),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text('Change Password'),
            ),
            SizedBox(height: 16),
            Text('Phone Number: $_phoneNumber'),
            ElevatedButton(
              onPressed: () => _changePhoneNumber(context),
              child: Text('Change Phone Number'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeName(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => _name = value,
              decoration: InputDecoration(labelText: 'Change Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_name.isNotEmpty) {
                await _profileServices.updateName(_userID, _name);
                print('Password changed successfully');
              } else {
                print('Invalid name input');
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    String oldPassword = "";
    String newPassword = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => oldPassword = value,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Old Password'),
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) => newPassword = value,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                await _profileServices.updatePassword(_userID, newPassword);
                print('Password changed successfully');
              } else {
                print('Invalid password input');
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePhoneNumber(BuildContext context) async {
    String newPhoneNumber = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Phone Number'),
        content: TextField(
          onChanged: (value) => newPhoneNumber = value,
          decoration: InputDecoration(labelText: 'New Phone Number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (newPhoneNumber.isNotEmpty) {
                // Call your service to update the phone number
                await _profileServices.updatePhoneNumber(
                    _userID, newPhoneNumber);
                print('Phone number changed successfully');
              } else {
                print('Invalid phone number input');
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
