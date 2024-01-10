import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/Notifier/user_state_notifier.dart';
import 'package:vidyamani/components/dashboard_component.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);

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
                        child: Image.network(
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_pin,
                                size: 16, color: Colors.white),
                           const  SizedBox(
                              width: 8,
                            ),
                            Text(
                              user?.location ?? "City",
                              style:
                              const    TextStyle(fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                 const   Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.published_with_changes, color: Colors.white),
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
