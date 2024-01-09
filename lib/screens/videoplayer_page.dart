import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:expandable_text/expandable_text.dart';

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

class VideoPlayerScreen extends StatefulWidget {
  final Videos video;
  final int index;
  final String? videoId;
  final String? userId;
  final String courseKey;

  VideoPlayerScreen({
    required this.video,
    required this.index,
    required this.videoId,
    required this.userId,
    required this.courseKey,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  late Future<List<Comments>> _commentsFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      looping: false,
      draggableProgressBar: true,
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: bgColor,
        handleColor: Colors.white,
      ),
    );
    _commentsFuture = _fetchComments();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    _commentController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<List<Comments>> _fetchComments() async {
    return await MiscellaneousService()
        .fetchAllComments(widget.courseKey, widget.videoId);
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
      userId: widget.userId ?? '',
      userName: 'John Doe',
    );

    try {
      await MiscellaneousService().addAndListCommentToVideoLecture(
        widget.userId ?? '',
        widget.courseKey,
        widget.videoId,
        newComment,
        context,
      );

      // Clear the comment and rating controllers
      _commentController.clear();
      _ratingController.clear();

      // Refresh the comments after submitting a new comment
      setState(() {
        _commentsFuture = _fetchComments();
      });
    } catch (e) {
      print('Failed to submit comment: $e');
    }
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
                  '${widget.index + 1} - ${widget.video.title}',
                  style: myTextStylefontsize16,
                ),
                SizedBox(
                  height: 10,
                ),
                ExpandableText(
                  widget.video.content,
                  expandText: 'Read more',
                  collapseText: 'Read less',
                  maxLines: 3,
                  style: myTextStylefontsize12Black,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Feedbacks',
                  style: myTextStylefontsize16,
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: _commentsFuture,
                  builder: (context, AsyncSnapshot<List<Comments>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
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
