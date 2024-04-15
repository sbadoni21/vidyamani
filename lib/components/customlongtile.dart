import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/utils/static.dart';

class VideoTile extends ConsumerStatefulWidget {
  final Videos video;

  VideoTile({
    required this.video,
  });

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends ConsumerState<VideoTile> {
  @override
  void initState() {
    super.initState();
    loadVideoData();
  }

  Future<void> loadVideoData() async {
    LectureDataService lectureService = LectureDataService();
  }

  @override
  Widget build(BuildContext context) {
    MiscellaneousService miscellaneousService = MiscellaneousService();

    return Container(
      color: Color.fromRGBO(240, 243, 248, 1),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: ListTile(
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'save') {
              print("called save");
              _saveLecture(context, miscellaneousService);
            } else if (value == 'unsave') {
              print("called unsave");
              _unsaveLecture(context, miscellaneousService);
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
        contentPadding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        title: Text('${widget.video.title}', style: myTextStylefontsize16),
        subtitle: Text(
          '${widget.video.content.split(' ').take(6).join(' ')}${widget.video.content.split(' ').length > 6 ? '...' : ''}',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                video: widget.video,
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveLecture(
      BuildContext context, MiscellaneousService miscellaneousService) async {
    User? user = ref.read(userStateNotifierProvider);

    if (user != null && widget.video.videoUid != null) {
      await miscellaneousService.addLectureToSaved(
        user!.uid,
        widget.video.lectureKey,
        widget.video.videoUid,
        context,
      );
    } else {
      print('User not authenticated.');
    }
  }

  void _unsaveLecture(
      BuildContext context, MiscellaneousService miscellaneousService) async {
    User? user = ref.read(userStateNotifierProvider);

    if (user != null && widget.video.videoUid != null) {
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
