import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/services/data/lectures_services.dart';


class SavedPage extends ConsumerStatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  late User? user;

  Future<User?> fetchData() async {
    try {
      return ref.watch(userProvider);
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          user = snapshot.data;

          return FutureBuilder<List<Videos>>(
            future: LectureDataService().fetchSavedVideos(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Videos> savedVideos = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: savedVideos.length,
                  itemBuilder: (context, index) {
                    Videos savedVideo = savedVideos[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        VideoTile(
                          video: savedVideo,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
