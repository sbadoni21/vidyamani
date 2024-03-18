import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/components/courses_list_tile.dart';
import 'package:vidyamani/components/coursestile_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/search_bar.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/services/data/search_course_lectures.dart';



class SearchBarButton extends ConsumerStatefulWidget {
  const SearchBarButton({Key? key}) : super(key: key);

  @override
  _SearchBarButtonState createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends ConsumerState<SearchBarButton> {
  List<Course> searchResults = [];
  List<dynamic> searchLectures = [];

  @override
  Widget build(BuildContext context) {
    User? user = ref.read(userProvider);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBarsection(
                          onSearch: (query) async {
                            List<Course> results = await SearchDataService()
                                .fetchAllCourses(searchQuery: query);
                            List<Videos> searchVideo = await SearchDataService()
                                .searchVideo(query, user!);
                            setState(() {
                              searchResults = results;
                              searchLectures = searchVideo;
                            });
                          },
                        ),
                        const SizedBox(height: 26),
                        const HeadingTitle(title: "Courses"),
                        const SizedBox(height: 16),
                        if (searchResults.isNotEmpty)
                          SizedBox(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                Course searchResult = searchResults[index];
                                return GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseDetailPage(
                                                    courses: searchResult)));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Tiles(
                                        course: searchResult,
                                      )),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 26),
                        const HeadingTitle(title: "Lectures"),
                        const SizedBox(height: 16),
                        if (searchLectures.isNotEmpty)
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: searchLectures.length,
                              itemBuilder: (context, index) {
                                Videos searchResult = searchLectures[index];
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreen(
                                                      video: searchResult)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child:
                                          VideoSearchTile(video: searchResult),
                                    ));
                              },
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
