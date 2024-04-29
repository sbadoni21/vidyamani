import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/components/customlongtile.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/buyplans_page.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/services/data/course_services.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/testimonals_service.dart';
import 'package:vidyamani/utils/static.dart';

class CourseDetailPage extends ConsumerStatefulWidget {
  final Course courses;

  CourseDetailPage({required this.courses});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

Future<void> _showReviewDialog(
    BuildContext context, User? user, Course course) async {
  double rating = 0.0;
  String review = "";

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              itemCount: 5,
              itemSize: 30.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter your review here...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                review = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await TestimonialService().addTestimonial(
                rating.toString(),
                review,
                course.lectureKey,
                course.courseKey,
                user?.photoURL,
                user?.uid,
                user?.displayName,
              );
              Navigator.of(context).pop();
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  double averageRating = 0.0;
  late User? user;
  bool isCourseSaved = false;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
    user = ref.read(userStateNotifierProvider);
    checkCourseSaved();
  }

  Future<void> checkCourseSaved() async {
    bool saved = await LectureDataService()
        .isCourseSaved(user!.uid, widget.courses.courseKey!);
    if (mounted) {
      setState(() {
        isCourseSaved = saved;
      });
    }
  }

  Future<void> _calculateAverageRating() async {
    LectureDataService lectureService = LectureDataService();

    double avgRating =
        await lectureService.calculateAverageRating(widget.courses.lectureKey!);
    if (mounted) {
      setState(() {
        averageRating = avgRating;
      });
    }

    await lectureService.updateOverallRating(
        widget.courses.lectureKey!, avgRating);
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              isCourseSaved ? "Unsave Course" : "Save Course to My Courses"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await saveOrUnsaveCourse();
                Navigator.of(context).pop();
              },
              child: Text("Proceed"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveOrUnsaveCourse() async {
    if (await LectureDataService()
        .isCourseSaved(user!.uid, widget.courses.courseKey!)) {
      await LectureDataService().unsaveCourse(user!.uid, widget.courses);
    } else {
      await LectureDataService().saveCourse(user!.uid, widget.courses);
    }

    await checkCourseSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          (widget.courses.type == "premium" && user?.type != "premium")
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: bgColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BuyPlans()));
                  },
                  child: Text("Buy Now"),
                )
              : null,
      appBar: CustomAppBarBckBtn(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: bgColor,
            child: Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.centerLeft,
                        child: Image.network(widget.courses.photo),
                      ),
                      TextButton(
                        onPressed: () {
                          if (user?.type == 'premium') {
                            _showReviewDialog(context, user, widget.courses);
                          }
                        },
                        child: Text(
                          (user?.type == 'premium') ? 'Add Review' : "",
                          style: myTextStylefontsize14White,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.courses.title,
                          style: myTextStylefontsize16white),
                      TextButton(
                        onPressed: () {
                          _showSaveDialog(context);
                        },
                        child: Text(
                          isCourseSaved ? "Unsave Course" : "Save Course",
                          style: myTextStylefontsize14White,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.courses.lectures?.toString() ?? ""} Lectures',
                              style: myTextStylefontsize10,
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2),
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: averageRating,
                              minRating: 1,
                              itemCount: 5,
                              itemSize: 15.0,
                              unratedColor: Colors.blueGrey[200],
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: (widget.courses.type == "free" ||
                    (widget.courses.type == "premium" &&
                        user?.type == "premium"))
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Course Content", style: myTextStylefontsize16),
                      const SizedBox(height: 8),
                      FutureBuilder<List<Videos>>(
                        future: DataService().fetchLecturesWithLectureKey(
                            widget.courses.lectureKey!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            print(snapshot.data!.length);
                            List<Videos> videos = snapshot.data ?? [];

                            print(videos.length);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: videos.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return VideoTile(
                                      video: videos[index],
                                    );
                                  },
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  )
                : Container(
                    child: Text(
                      "Buy Now to Access Premium Content",
                      style: myTextStylefontsize16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
