import 'package:flutter/material.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/utils/static.dart';

class VideoTile extends StatelessWidget {
  final Videos video;
  final int index;
  final String courseKey;

  VideoTile({
    required this.video,
    required this.index,
    required this.courseKey,
  });

  @override
  Widget build(BuildContext context) {
    MiscellaneousService miscellaneousService = MiscellaneousService();
    AuthenticationServices authService = AuthenticationServices();
    LectureDataService lectureService = LectureDataService();

    return FutureBuilder(
      future: _loadData(authService, lectureService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String? userId = snapshot.data?['userId'];
          String? videoUids = snapshot.data?['videoUids'];

          return Container(
            color: Color.fromRGBO(240, 243, 248, 1),
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            child: ListTile(
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'save') {
                    print("called save");
                    _saveLecture(
                        userId, videoUids, context, miscellaneousService);
                  } else if (value == 'unsave') {
                    print("called unsave");
                    _unsaveLecture(
                        userId, videoUids, context, miscellaneousService);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'save',
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: Icon(Icons.save),
                      title: Text('Save'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'unsave',
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: Icon(Icons.delete),
                      title: Text('Unsave'),
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 4),
              title: Text('${index + 1} - ${video.title}',
                  style: myTextStylefontsize16),
              subtitle: Text(
                '${video.content.split(' ').take(6).join(' ')}${video.content.split(' ').length > 6 ? '...' : ''}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      video: video,
                      index: index,
                      userId: userId,
                      videoId: videoUids,
                      courseKey: courseKey,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return CircularProgressIndicator(); // or any other loading indicator
        }
      },
    );
  }

  Future<Map<String, String?>> _loadData(AuthenticationServices authService,
      LectureDataService lectureService) async {
    String? userId = await authService.getCurrentUserId();
    String? videoUids =
        await lectureService.fetchLectureUidByIndex(courseKey, index);

    return {'userId': userId, 'videoUids': videoUids};
  }

  void _saveLecture(String? userId, String? videoUids, BuildContext context,
      MiscellaneousService miscellaneousService) async {
    if (userId != null && videoUids != null) {
      print('User ID: $userId');
      print('Video Uids: $videoUids');
      await miscellaneousService.addLectureToSaved(
        userId,
        courseKey,
        videoUids,
        context,
      );
    } else {
      print('User not authenticated.');
    }
  }

  void _unsaveLecture(String? userId, String? videoUids, BuildContext context,
      MiscellaneousService miscellaneousService) async {
    if (userId != null && videoUids != null) {
      print('User ID: $userId');
      print('Video Uids: $videoUids');
      await miscellaneousService.removeLectureFromSaved(
        userId,
        courseKey,
        videoUids,
        context,
      );
    } else {
      print('User not authenticated.');
    }
  }
}
