import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/services/auth/authentication.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class VideoTile extends ConsumerStatefulWidget {
  final Videos video;
  final int? index;
  final String lectureKey;

  VideoTile({
    required this.video,
    this.index,
    required this.lectureKey,
  });
  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends ConsumerState<VideoTile> {
  late User? user;

  @override
  void initState() {
    super.initState();

    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    MiscellaneousService miscellaneousService = MiscellaneousService();

    LectureDataService lectureService = LectureDataService();

    return FutureBuilder(
      future: _loadData(lectureService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String? videoUids = snapshot.data?['videoUid'];

          return Container(
            color: Color.fromRGBO(240, 243, 248, 1),
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            child: ListTile(
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'save') {
                    print("called save");
                    _saveLecture(videoUids, context, miscellaneousService);
                  } else if (value == 'unsave') {
                    print("called unsave");
                    _unsaveLecture(
                        user!.uid, videoUids, context, miscellaneousService);
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
              title: Text('${widget.index! + 1} - ${widget.video.title}',
                  style: myTextStylefontsize16),
              subtitle: Text(
                '${widget.video.content.split(' ').take(6).join(' ')}${widget.video.content.split(' ').length > 6 ? '...' : ''}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      video: widget.video,
                      index: widget.index!,
                      videoId: widget.video.videoUid,
                      courseKey: widget.video.lectureKey,
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

  Future<Map<String, String?>> _loadData(
      LectureDataService lectureService) async {
    String? userId = user!.uid;
    String? videoUids = await lectureService.fetchLectureUidByIndex(
        widget.lectureKey, widget.index!);

    return {'userId': userId, 'videoUid': videoUids};
  }

  void _saveLecture(String? videoUids, BuildContext context,
      MiscellaneousService miscellaneousService) async {
    print('Video Uid: $videoUids');
    if (user != null && videoUids != null) {
      await miscellaneousService.addLectureToSaved(
        user!.uid,
        widget.lectureKey,
        videoUids,
        context,
      );
    } else {
      print('User not authenticated.');
    }
  }

  void _unsaveLecture(String? userId, String? videoUids, BuildContext context,
      MiscellaneousService miscellaneousService) async {
    if (userId != null) {
      await miscellaneousService.removeLectureFromSaved(
        user!.uid,
        widget.video.lectureKey,
        widget.video.videoUid,
        context,
      );
    } else {
      print('User not authenticated.');
    }
  }
}
