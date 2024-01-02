import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vidyamani/components/bottomnavbar_component.dart';
import 'package:vidyamani/components/categories_component.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/components/testimonals_component.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/screens/course_detailspage.dart';
import 'package:vidyamani/screens/courses_page.dart';

import 'package:logger/logger.dart';
import 'package:vidyamani/screens/notes_page.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/screens/search_page.dart';
import 'package:vidyamani/screens/videoplayer_page.dart';
import 'package:vidyamani/services/data/course_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late List<String> imageUrls;
  late List<Course> coursesData;
  final DataService _dataService = DataService();
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();
    coursesData = [];
    fetchImageUrls();
    imageUrls = [];
    // fetchCourses();
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
      print('Image Data:');
      for (String url in imageUrls) {
        print('Image URL: $url');
      }
    });
  }

  Future<List<Course>> fetchCourses() async {
    List<Course> fetchedCourses = await _dataService.fetchCollectionData();
    logger.i(fetchedCourses);
    return fetchedCourses;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: IndexedStack(index: currentIndex, children: [
          _buildHomePage(context),
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

  Widget _buildHomePage(BuildContext context) {
    return FutureBuilder(
      future: fetchCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          coursesData = snapshot.data as List<Course>;

          return Scaffold(
            body: ListView(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.normal,
                    ),
                    height: 229.0,
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingTitle(title: "Categories"),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CategoryItem(
                                imgUrl:
                                    "lib/assets/images/skillbasedcourses.png",
                                text: "Categories",
                                pageRoute: MaterialPageRoute(
                                  builder: (context) => CourseDetailPage(),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CategoryItem(
                                imgUrl:
                                    "lib/assets/images/skillbasedcourses.png",
                                text: "Categories",
                                pageRoute: MaterialPageRoute(
                                  builder: (context) => CourseDetailPage(),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CategoryItem(
                                imgUrl:
                                    "lib/assets/images/skillbasedcourses.png",
                                text: "Categories",
                                pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      HeadingTitle(title: "Featured Courses"),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: coursesData.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: coursesData.length,
                                itemBuilder: (context, index) {
                                  Course course = coursesData[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Tiles(
                                      imagePath: course.photo,
                                      text1: course.type,
                                      text2: course.title,
                                      pageRoute: MaterialPageRoute(
                                        builder: (context) =>
                                            CourseDetailPage(),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Text("No courses available."),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      HeadingTitle(title: "Upcoming lectures"),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Tiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                          SizedBox(
                            width: 3,
                          ),
                          Tiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                          SizedBox(
                            width: 3,
                          ),
                          Tiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                          SizedBox(
                            width: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      HeadingTitle(title: "Live Lectures"),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          CiruclarTiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                          SizedBox(
                            width: 3,
                          ),
                          CiruclarTiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                          SizedBox(
                            width: 3,
                          ),
                          CiruclarTiles(
                              imagePath:
                                  "lib/assets/images/featuredcourses.png",
                              text1: "Basic Courses",
                              text2: "basic course",
                              pageRoute: MaterialPageRoute(
                                  builder: (context) => CoursesPage())),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      HeadingTitle(title: "Testimonials"),
                      SizedBox(
                        height: 16,
                      ),
                      Testimonials(
                        imagePath: 'lib/assets/images/featuredcourses.png',
                        name: 'John Doe',
                        testimonial:
                            'This is an amazing testimonial. I highly recommend!',
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
