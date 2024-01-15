import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/courses_page.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/profile/history_service.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class SavedPage extends ConsumerStatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  late User? user;
  List<String> selectedVideoIds = [];

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
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
                    index: index,
                    lectureKey: savedVideo.videoUid,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
