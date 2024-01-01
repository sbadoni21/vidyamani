import 'dart:async';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';

class Comment {
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment(this.userName, this.text, this.timestamp);
}

List<Comment> comments = [];

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isBookmarked = false;
  bool isVolumeSliderVisible = false;
  Timer? _positionUpdateTimer;
  TextEditingController commentController = TextEditingController();
  late List<Uri> videoUrls = [];
  bool isExpanded = false;
  int currentVideoIndex = 0;
  double sliderValue = 0.0;
  bool isLoading = true;
  var _initializeVideoPlayerFuture;
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _onVideoEnded() {
    // Load the next video when the current one ends
    _loadNextVideo();
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<void> fetchImageUrls() async {
    Reference reference = FirebaseStorage.instance.ref().child('videos');
    ListResult result = await reference.listAll();

    List<Uri> urls = await Future.wait(
      result.items.map((Reference ref) async {
        String url = await ref.getDownloadURL();
        return Uri.parse(url);
      }),
    );

    setState(() {
      videoUrls = urls;
      _initializeVideoPlayer();
      isLoading = false;
      logger.i(videoUrls);
    });
  }

  void _initializeVideoPlayer() {
    if (videoUrls.isNotEmpty) {
      _controller = VideoPlayerController.network(videoUrls[0].toString());

      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          // Video has ended, call the callback
          _onVideoEnded();
        }
      });

      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        setState(() {});
        _positionUpdateTimer =
            Timer.periodic(const Duration(milliseconds: 500), (timer) {
          if (mounted) {
            setState(() {});
          }
        });
      });
    } else {
      // Handle the case where there are no video URLs.
      // You can show an error message or take appropriate action.
    }
  }

  void _loadNextVideo() {
    if (currentVideoIndex < videoUrls.length - 1) {
      currentVideoIndex++;
      final nextVideoUrl = videoUrls[currentVideoIndex];
      _controller = VideoPlayerController.network(nextVideoUrl.toString());

      // Add listener for end of video playback
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          // Video has ended, call the callback
          _onVideoEnded();
        }
      });

      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.play();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  void _loadPreviousVideo() {
    if (currentVideoIndex != 0) {
      currentVideoIndex--;
      final nextVideoUrl = videoUrls[currentVideoIndex];
      _controller = VideoPlayerController.asset(nextVideoUrl.toString());
      _controller.initialize();
      _controller.play();
      setState(() {});
    }
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionUpdateTimer?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _formatDuration(_controller.value.position),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatDuration(_controller.value.duration),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              value: _controller.value.position.inSeconds.toDouble(),
              onChanged: (double value) {
                final Duration newPosition = Duration(seconds: value.toInt());
                setState(() {
                  _controller.seekTo(newPosition);
                });
              },
              min: 0,
              max: _controller.value.duration.inSeconds.toDouble(),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        final newPosition = _controller.value.position -
                            const Duration(seconds: 10);
                        _controller.seekTo(newPosition);
                      });
                    },
                    icon: const Icon(Icons.replay_10_rounded),
                  ),
                  TextButton(
                    onPressed: () {
                      _loadPreviousVideo();
                    },
                    child: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.stop
                        : Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      _loadNextVideo();
                    },
                    icon: const Icon(Icons.skip_next),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        final newPosition = _controller.value.position +
                            const Duration(seconds: 10);
                        _controller.seekTo(newPosition);
                      });
                    },
                    icon: const Icon(Icons.forward_10_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isBookmarked = !_isBookmarked;
                      });
                    },
                    icon: Icon(Icons.bookmark,
                        color: _isBookmarked ? Colors.blue : Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: _toggleExpansion,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: isExpanded ? 150.0 : 60.0,
                  child: isExpanded
                      ? Container(
                          color: Colors.amber,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Line 1'),
                              Text('Line 2'),
                              Text('Line 3'),
                              Text('Line 1'),
                              Text('Line 2'),
                              Text('Line 3'),
                            ],
                          ),
                        )
                      : Container(
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Line 1'),
                              Text('Line 2'),
                              Text('Line 3'),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                children: [
                  Text(
                    "Comments",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Add a public comment...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final newComment = Comment(
                          'User', commentController.text, DateTime.now());
                      setState(() {
                        comments.add(newComment);
                      });
                      commentController.clear();
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: 250,
              height: 300,
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(comment.userName),
                    subtitle: Text(comment.text),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
