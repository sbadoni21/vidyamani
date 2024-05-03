import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
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
import 'package:vidyamani/screens/chatgpt_page.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/screens/meetingdetail_page.dart';
import 'package:vidyamani/screens/notes_page.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/screens/search_page.dart';
import 'package:vidyamani/screens/upcoming_page.dart';
import 'package:vidyamani/services/admanager/ad_service.dart';
import 'package:vidyamani/services/data/course_services.dart';
import 'package:vidyamani/services/data/crousaldata_service.dart';
import 'package:vidyamani/services/data/livelecture_service.dart';
import 'package:vidyamani/services/data/search_course_lectures.dart';
import 'package:vidyamani/services/data/subscription_service.dart';
import 'package:vidyamani/services/data/testimonals_service.dart';

final adProvider = ChangeNotifierProvider<AdProvider>(
  (ref) => AdProvider(),
);

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
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  late PageController _pageController;
  int _selectedIndex = 0;
  late Timer _timer;
  final Duration refreshInterval = const Duration(minutes: 10);
  final Duration displayAdsInterval = const Duration(minutes: 10);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;
  @override
  void initState() {
    super.initState();
    fetchData();
    setupRefreshTimer();
    meetingProvider.getMeetings();
    _pageController = PageController();
    Future.delayed(const Duration(hours: 2), () {
      fetchSubscriptionStatus();
    });
    user = ref.read(userStateNotifierProvider);
    Future.delayed(const Duration(seconds: 10), () {
      if (user!.type == 'free') {
        adProvider.createInterstitialAd();
        adProvider.createRewardedAd();
        adProvider.createRewardedInterstitialAd();
        displayAds();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
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
    coursesData = await fetchFeaturedCollectionData();
  }

  Future<void> fetchSubscriptionStatus() async {
    await SubscriptionService().fetchSubscriptionStatus(user!.uid);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Course>> fetchFeaturedCollectionData() async {
    List<Course> fetchedCourses =
        await _dataService.fetchFeaturedCoursesCollectionData();
    return fetchedCourses;
  }

  Future<List<Course>> fetchUpcomingCollectionData() async {
    List<Course> upcomingCourses =
        await _dataService.fetchUpcomingCoursesCollectionData();
    return upcomingCourses;
  }

  Future<List<Review>> fetchTestimonials() async {
    List<Review> testimonials =
        await TestimonialService().fetchCollectionData();

    return testimonials;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: GestureDetector(
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: const CustomAppBar(),
            body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  _buildHomePage(context, ref, adProvider),
                  const SearchBarButton(),
                  ChatGPTPage(trigger: 0),
                  const MyNotes(),
                  const ProfilePage(),
                ]),
            bottomNavigationBar: CustomBottomNavigationBar(
                currentIndex: _selectedIndex, onTap: _onItemTapped),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(
      BuildContext context, WidgetRef ref, AdProvider adProvider) {
    final meetingService = ref.read(meetingServiceProvider);
    final carousalAsyncValue = ref.watch(carousalProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchTestimonials();
          await fetchData();
          await fetchSubscriptionStatus();
        },
        child: ListView(
          children: [
            Consumer(
              builder: (context, watch, child) {
                return carousalAsyncValue.when(
                  data: (carousalList) {
                    return carousalAsyncValue.hasValue == null
                        ? const SizedBox()
                        : CarouselSlider(
                            options: CarouselOptions(
                              scrollPhysics: const BouncingScrollPhysics(
                                decelerationRate: ScrollDecelerationRate.normal,
                              ),
                              viewportFraction: 1,
                              aspectRatio: 16 / 9,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: carousalList.map((carousal) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Image.network(
                                    carousal.photo,
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            }).toList(),
                          );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text('Error: $error'),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: HeadingTitle(title: "Categories"),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder<List<Category>>(
                  future: SearchDataService().getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No categories found.'));
                    } else {
                      List<Category> categoriesData = snapshot.data!;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
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
                                      builder: (context) => AllCoursesPage(
                                          selectedCategory: category),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: CategoryItem(
                                    imgUrl: category.image,
                                    text: category.headingName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
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
                      return featuredCourses.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const HeadingTitle(title: "Featured Courses"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  SizedBox(
                                    height: 170,
                                    child: featuredCourses.isNotEmpty
                                        ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: featuredCourses.length,
                                            itemBuilder: (context, index) {
                                              Course course =
                                                  featuredCourses[index];
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, right: 8),
                                                  child: Tiles(course: course),
                                                ),
                                              );
                                            },
                                          )
                                        : const Text(
                                            "No featured courses available."),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: fetchUpcomingCollectionData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Course> upcomingCourses =
                          snapshot.data as List<Course>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const HeadingTitle(title: "Upcoming Courses"),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 170,
                              child: upcomingCourses.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: upcomingCourses.length,
                                      itemBuilder: (context, index) {
                                        Course course = upcomingCourses[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingCourses(
                                                        courses: course),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Tiles(
                                              course: course,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const Text("No Courses available."),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Meeting>>(
                  future: meetingService.getMeetings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Meeting> meetings = snapshot.data ?? [];

                      return meetings.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const HeadingTitle(title: "Live Lectures"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  SizedBox(
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8),
                                                    child: CiruclarTiles(
                                                      meeting: meeting,
                                                    )),
                                              );
                                            },
                                          )
                                        : const Text("No meetings available."),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                    }
                  },
                ),
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
                      return testimonials.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const HeadingTitle(title: "Testimonials"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  SizedBox(
                                      height: 180,
                                      child: testimonials.isNotEmpty
                                          ? ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: testimonials.length,
                                              itemBuilder: (context, index) {
                                                Review testimonial =
                                                    testimonials[index];
                                                return TestimonialCard(
                                                    testimonial: testimonial);
                                              },
                                            )
                                          : const Center(
                                              child: Text(
                                                  "No testimonials available."))),
                                ],
                              ),
                            )
                          : SizedBox();
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBackDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure you want to exit?"),
            actions: <Widget>[
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        });
  }
}
