import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/services/profile/history_service.dart';



class HistoryPage extends ConsumerStatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<HistoryPage> {
  late User? user;
  List<String> historyVideo = [];

  @override
  void initState() {
    super.initState();
    user = ref.read(userStateNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Videos>>(
      future: HistoryService().fetchSavedVideos(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Videos> historyVideos = snapshot.data ?? [];

          return ListView.builder(
            itemCount: historyVideos.length,
            itemBuilder: (context, index) {
              Videos historyVideo = historyVideos[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  VideoTile(
                    video: historyVideo,
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
