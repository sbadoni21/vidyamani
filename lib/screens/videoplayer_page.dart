import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/services/admanager/ad_service.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/services/data/watch_time_service.dart';
import 'package:vidyamani/services/profile/history_service.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});
final adProvider = ChangeNotifierProvider<AdProvider>(
  (ref) => AdProvider(),
);

class CommentsWidget extends StatefulWidget {
  final List<Comments> comments;
  CommentsWidget({required this.comments, Key? key}) : super(key: key);
  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Color.fromRGBO(240, 243, 248, 1),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      width: double.infinity,
      child: ListView.builder(
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.comments[index].userName}',
                        style: myTextStylefontsize14,
                      ),
                      if (widget.comments[index].rating == "not rated")
                        Text('No Rating')
                      else
                        RatingBar.builder(
                          initialRating:
                              double.parse(widget.comments[index].rating),
                          minRating: 1,
                          itemCount: 5,
                          itemSize: 15.0,
                          unratedColor: Colors.blueGrey[200],
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: bgColor,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                    ],
                  ),
                  Text(
                    widget.comments[index].comment,
                    style: myTextStylefontsize12Black,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final Videos video;

  VideoPlayerScreen({
    required this.video,
  });
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  final AdProvider adProvider = AdProvider();
  late ChewieController _chewieController;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  late Future<List<Comments>> _commentsFuture;
  bool _isLoading = true;
  late User? user;
  late Timer? _timer;
  bool _isTimerStarted = false;
  final Duration refreshInterval = const Duration(minutes: 10);
  final WatchTimeService watchTimeService = WatchTimeService();
  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    if (user!.type == 'free') {
      adProvider.createRewardedInterstitialAd();
      adProvider.showRewardedInterstitialAd(user!);
      adTimer();
    }

    _controller = VideoPlayerController.network(
      widget.video.videoUrl,
    );
    _chewieController = ChewieController(
      autoInitialize: true,
      allowPlaybackSpeedChanging: true,
      showControlsOnInitialize: true,
      allowMuting: true,
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.white24,
      ),
      videoPlayerController: _controller,
      looping: false,
      draggableProgressBar: true,
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: bgColor,
        handleColor: Colors.white,
        bufferedColor: bgColor,
      ),
    );
    _commentsFuture = _fetchComments();
    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        if (!_isTimerStarted) {
          _startTimer();
        }
      } else {
        _stopTimer();
      }
    });
    sendDataToFirebase();
  }

  void _startTimer() {
    _isTimerStarted = true;
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      _incrementWatchTime();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerStarted = false;
  }

  @override
  void dispose() {
    _stopTimer();
    _controller.dispose();
    _chewieController.dispose();
    _commentController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> sendDataToFirebase() async {
    try {
      await HistoryService().sendHistoryVideos(user!.uid, widget.video);
    } catch (error) {
      print('Error sending data to Firebase: $error');
    }
  }

  Future<List<Comments>> _fetchComments() async {
    return await MiscellaneousService()
        .fetchAllComments(widget.video.lectureKey, widget.video.videoUid);
  }

  void _submitComment() async {
    if (_commentController.text.isEmpty) {
      return;
    }
    Comments newComment = Comments(
      rating: _ratingController.text.isNotEmpty
          ? _ratingController.text
          : 'not rated',
      comment: _commentController.text,
      userId: user?.uid ?? '',
      userName: user!.displayName,
    );
    try {
      await MiscellaneousService().addAndListCommentToVideoLecture(
        user?.uid ?? '',
        widget.video.lectureKey,
        widget.video.videoUid,
        newComment,
        context,
      );
      _commentController.clear();
      _ratingController.clear();
      setState(() {
        _commentsFuture = _fetchComments();
      });
    } catch (e) {
      print('Failed to submit comment: $e');
    }
  }

  void adTimer() {
    _timer = Timer.periodic(refreshInterval, (Timer timer) {
      adProvider.showRewardedInterstitialAd(user!);
    });
  }

  void _incrementWatchTime() {
    watchTimeService.updateWatchTime(
      user!.uid,
      widget.video.videoUid,
      widget.video.lectureKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Chewie(controller: _chewieController),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${widget.video.title}',
                  style: myTextStylefontsize16,
                ),
                const SizedBox(
                  height: 10,
                ),
                ExpandableText(
                  widget.video.content,
                  expandText: 'Read more',
                  collapseText: 'Read less',
                  maxLines: 3,
                  style: myTextStylefontsize12Black,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Feedbacks',
                  style: myTextStylefontsize16,
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: _commentsFuture,
                  builder: (context, AsyncSnapshot<List<Comments>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      _isLoading = false;
                      return _isLoading
                          ? CircularProgressIndicator()
                          : CommentsWidget(
                              key: UniqueKey(), comments: snapshot.data ?? []);
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar.builder(
                      initialRating: double.parse(
                          _ratingController.text.isNotEmpty
                              ? _ratingController.text
                              : '0'),
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 20.0,
                      unratedColor: Colors.blueGrey[200],
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: bgColor,
                      ),
                      onRatingUpdate: (rating) {
                        _ratingController.text = rating.toString();
                      },
                    ),
                    Text(
                      "Rate Lecture",
                      style: myTextStylefontsize10BGCOLOR,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            focusColor: bgColor,
                            hintText: 'Add a comment...',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Adjust spacing as needed
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: bgColor),
                        onPressed: _submitComment,
                        child: Text(
                          'Submit',
                          style: myTextStylefontsize14White,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
