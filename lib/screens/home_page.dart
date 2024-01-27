import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/components/allcourse_component.dart';
import 'package:vidyamani/components/bottomnavbar_component.dart';
import 'package:vidyamani/components/categories_component.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/coursestile_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/testimonals_component.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/models/categories_model.dart';
import 'package:vidyamani/models/course_lectures_model.dart';
import 'package:vidyamani/models/meeting_model.dart';
import 'package:vidyamani/models/testimonial_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/screens/meetingdetail_page.dart';
import 'package:vidyamani/screens/notes_page.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/screens/search_page.dart';
import 'package:vidyamani/services/admanager/ad_service.dart';
import 'package:vidyamani/services/data/course_services.dart';
import 'package:vidyamani/services/data/lectures_services.dart';
import 'package:vidyamani/services/data/livelecture_service.dart';
import 'package:vidyamani/services/data/testimonals_service.dart';

final adProvider = ChangeNotifierProvider<AdProvider>(
  (ref) => AdProvider(),
);

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;
  final AdProvider adProvider = AdProvider();
  final MeetingService meetingProvider = MeetingService();
  late List<String> imageUrls = [];
  late List<Course> coursesData = [];
  late List<Lectures> fetchedLectures = [];
  final DataService _dataService = DataService();
  final LectureDataService _lectureService = LectureDataService();
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  late Timer _timer;
  final Duration refreshInterval = const Duration(minutes: 10);
  final Duration displayAdsInterval = const Duration(minutes: 10);

  User? user;
  @override
  void initState() {
    super.initState();
    fetchData();
    setupRefreshTimer();
    fetchImageUrls();
    meetingProvider.getMeetings();

    user = ref.read(userProvider);
    Future.delayed(const Duration(seconds: 10), () {
      if (user!.type == 'free') {
        adProvider.createInterstitialAd();
        adProvider.createRewardedAd();
        adProvider.createRewardedInterstitialAd();
        displayAds();
      }
    });
  }

  void setupRefreshTimer() {
    _timer = Timer.periodic(refreshInterval, (Timer timer) {
      fetchData();
    });
  }

  void displayAds() {
    _timer = Timer.periodic(displayAdsInterval, (Timer timer) {
      adProvider.showRewardedInterstitialAd(user!, context);
    });
  }

  Future<void> fetchData() async {
    await fetchImageUrls();
    coursesData = await fetchFeaturedCollectionData();
    fetchedLectures = await fetchCoursesLectures();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchImageUrls() async {
    Reference reference =
        FirebaseStorage.instance.ref().child('carouselImages');
    ListResult result = await reference.listAll();

    List<String> urls = await Future.wait(
      result.items.map((Reference ref) => ref.getDownloadURL()),
    );

    setState(() {
      imageUrls = urls;
    });
  }

  Future<List<Course>> fetchFeaturedCollectionData() async {
    List<Course> fetchedCourses =
        await _dataService.fetchFeaturedCollectionData();
    logger.i(fetchedCourses);
    return fetchedCourses;
  }

  Future<List<Review>> fetchTestimonials() async {
    List<Review> testimonials =
        await TestimonialService().fetchCollectionData();

    return testimonials;
  }

  Future<List<Lectures>> fetchCoursesLectures() async {
    List<Lectures> fetchedLectures =
        await _lectureService.fetchCollectionData();
    logger.i(fetchedLectures);
    return fetchedLectures;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: IndexedStack(index: currentIndex, children: [
          _buildHomePage(context, ref, adProvider),
          const SearchBarButton(),
          const MyNotes(),
          const ProfilePage(),
        ]),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildHomePage(
      BuildContext context, WidgetRef ref, AdProvider adProvider) {
    final meetingService = ref.read(meetingServiceProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchImageUrls();
          await fetchTestimonials();
          await fetchData();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 19),
              child: CarouselSlider(
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  height: 229.0,
                  viewportFraction: 1,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
                items: imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        url,
                        fit: BoxFit.fill,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeadingTitle(title: "Categories"),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 130.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesData.length,
                      itemBuilder: (context, index) {
                        Category category = categoriesData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllCoursesPage(selectedCategory: category),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: CategoryItem(
                              imgUrl: category.image,
                              text: category.name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const HeadingTitle(title: "Featured Courses"),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                    future: fetchFeaturedCollectionData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Course> featuredCourses =
                            snapshot.data as List<Course>;

                        return SizedBox(
                          height: 170,
                          child: featuredCourses.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: featuredCourses.length,
                                  itemBuilder: (context, index) {
                                    Course course = featuredCourses[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CourseDetailPage(
                                                    courses: course),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Tiles(course: course),
                                      ),
                                    );
                                  },
                                )
                              : const Text("No featured courses available."),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const HeadingTitle(title: "Upcoming Courses"),
                  const SizedBox(
                    height: 16,
                  ),
                  // FutureBuilder(
                  //   future: fetchCoursesLectures(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text('Error: ${snapshot.error}'));
                  //     } else {
                  //       List<Lectures> featuredCourses =
                  //           snapshot.data as List<Lectures>;

                  //       return SizedBox(
                  //         height: 170,
                  //         child: featuredCourses.isNotEmpty
                  //             ? ListView.builder(
                  //                 scrollDirection: Axis.horizontal,
                  //                 itemCount: featuredCourses.length,
                  //                 itemBuilder: (context, index) {
                  //                   Lectures lecture = featuredCourses[index];
                  //                   return GestureDetector(
                  //                     //                 onTap: () {
                  //                     //   Navigator.push(
                  //                     //     context,
                  //                     //     MaterialPageRoute(
                  //                     //       builder: (context) =>
                  //                     //           CourseDetailPage(lecture: lecture),
                  //                     //     ),
                  //                     //   );
                  //                     // },
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.only(
                  //                           left: 8.0, right: 8),
                  //                       child: Tiles(
                  //                         imagePath: lecture.photo,
                  //                         text1: lecture.type,
                  //                         text2: lecture.title,
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               )
                  //             : const Text("No lectures available."),
                  //       );
                  //     }
                  //   },
                  // ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const HeadingTitle(title: "Live Lectures"),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder<List<Meeting>>(
                    future: meetingService.getMeetings(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Meeting> meetings = snapshot.data ?? [];

                        return SizedBox(
                          height: 200,
                          child: meetings.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: meetings.length,
                                  itemBuilder: (context, index) {
                                    Meeting meeting = meetings[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MeetingDetailPage(
                                                    meeting: meeting),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: CiruclarTiles(
                                            meeting: meeting,
                                          )),
                                    );
                                  },
                                )
                              : const Text("No meetings available."),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const HeadingTitle(title: "Testimonials"),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder<List<Review>>(
                    future: fetchTestimonials(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Review> testimonials = snapshot.data ?? [];
                        return SizedBox(
                            height: 180,
                            child: testimonials.isNotEmpty
                                ? ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: testimonials.length,
                                    itemBuilder: (context, index) {
                                      Review testimonial = testimonials[index];
                                      return TestimonialCard(
                                          testimonial: testimonial);
                                    },
                                  )
                                : const Center(
                                    child: Text("No testimonials available.")));
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
