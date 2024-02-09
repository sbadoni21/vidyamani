import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/components/dashboard_component.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/services/profile/profile_services.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  late User? user;
  String obscuringCharacter = '*';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          user = snapshot.data;
          return buildProfilePage(context);
        }
      },
    );
  }

  Future<User?> fetchData() async {
    try {
      return ref.watch(userProvider);
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            "Change Password",
            style: myTextStylefontsize24,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                obscuringCharacter: obscuringCharacter,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  helperStyle: TextStyle(color: Colors.white),
                ),
                style: myTextStylefontsize14White,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                obscuringCharacter: obscuringCharacter,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  helperStyle: TextStyle(color: Colors.white),
                ),
                style: myTextStylefontsize14White,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                obscuringCharacter: obscuringCharacter,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  helperStyle: TextStyle(color: Colors.white),
                ),
                style: myTextStylefontsize14White,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: bgColor,
                ),
                onPressed: () async {
                  String oldPassword = oldPasswordController.text;
                  String newPassword = newPasswordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (newPassword != confirmPassword) {
                    _showSnackBar(context, 'New passwords do not match');
                    return;
                  }

                  try {
                    await ProfileServices().validateOldPassword(
                        user?.uid ?? "", oldPassword, user?.email ?? "");
                    await ProfileServices().updatePassword(
                      user?.uid ?? "",
                      newPassword,
                    );

                    _showSnackBar(context, 'Password updated successfully');
                  } catch (e) {
                    _showSnackBar(context, 'Error updating password: $e');
                  }

                  Navigator.pop(context);
                },
                child: const Text('Update Password'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget buildProfilePage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
            alignment: Alignment.bottomCenter,
            height: 180,
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                            child: user == null
                                ? Image.asset(
                                    'lib/assets/images/placeholder_image.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    user!.photoURL,
                                    width: 120,
                                    height: 120,
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
                              user?.displayName ?? "Name",
                              style: myTextStylefontsize16white,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    size: 20, color: Colors.white),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  user?.location ?? "City",
                                  style: myTextStylefontsize14White,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    user!.isGoogleUser != true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _showChangePasswordDialog(context),
                                icon: const Icon(Icons.published_with_changes,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Change",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              const Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Dashboard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
