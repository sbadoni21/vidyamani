import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/buyplans_page.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/services/data/datetimehelper_service.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/testimonals_service.dart';
import 'package:vidyamani/utils/static.dart';


class UpcomingCourses extends ConsumerStatefulWidget {
  final Course courses;

  UpcomingCourses({required this.courses});

  @override
  _UpcomingCourseDetailState createState() => _UpcomingCourseDetailState();
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
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
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
            child: const Text("Cancel"),
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

class _UpcomingCourseDetailState extends ConsumerState<UpcomingCourses> {
  double averageRating = 0.0;
  late User? user;
  bool isCourseSaved = false;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
    user = ref.read(userProvider);
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

  void _showPaymentGatewayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Gateway"),
          content: const Text("Implement your payment gateway UI here."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Proceed"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
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
              child: const Text("Proceed"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
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
    String formattedMeetingTimeEnd =
        DateTimeHelper.formatMeetingTime(widget.courses.startTime!);
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
            padding: const EdgeInsets.all(16),
            color: bgColor,
            child: Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
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
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.courses.title,
                          style: myTextStylefontsize16white),
                      Text(
                        "upcoming",
                        style: myTextStylefontsize24,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
              padding: const EdgeInsets.all(20.0),
              child: HeadingTitle(title: 'About')),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ExpandableText(
              widget.courses.description!,
              expandText: "..show more",
              maxLines: 5,
              animation: true,
              animationDuration: const Duration(milliseconds: 500),
              animationCurve: Curves.easeIn,
              collapseOnTextTap: true,
              linkColor: bgColor,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cardColor,
              ),
              width: double.infinity,
              height: 250,
              child: Stack(
                children: [
                  Positioned(right: 0, child: Image.asset(logohalf)),
                  Positioned(
                      left: 20,
                      top: 36,
                      child: Text(
                        'Coming Soon...',
                        style: myTextStylefontsize24BGCOLOR,
                      )),
                  Positioned(
                      left: 20,
                      top: 115,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            formattedMeetingTimeEnd,
                            style: myTextStylefontsize24BGCOLOR,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
