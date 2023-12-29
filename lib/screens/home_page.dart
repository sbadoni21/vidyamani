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
import 'package:vidyamani/screens/courses_page.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/screens/profile_page.dart';
import 'package:vidyamani/utils/static.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late List<String> imageUrls = [];
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  @override
  void initState() {
    super.initState();
    fetchImageUrls();
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
      logger.i(imageUrls);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: IndexedStack(index: currentIndex, children: [
          _buildHomePage(context),
          const ProfilePage(),
          const ProfilePage(),
          const ProfilePage(),
        ]),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }

  Widget _buildHomePage(BuildContext context) {
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
                          imgUrl: "lib/assets/images/skillbasedcourses.png",
                          text: "Categories",
                          pageRoute: MaterialPageRoute(
                            builder: (context) => Courses(),
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
                Tiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => Courses())),
                SizedBox(
                  height: 16,
                ),
                HeadingTitle(title: "Upcoming lectures"),
                SizedBox(
                  height: 16,
                ),
                Tiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => Courses())),
                SizedBox(
                  height: 16,
                ),
                HeadingTitle(title: "Live Lectures"),
                SizedBox(
                  height: 16,
                ),
                CiruclarTiles(
                    imagePath: "lib/assets/images/featuredcourses.png",
                    text1: "Basic Courses",
                    text2: "basic course",
                    pageRoute:
                        MaterialPageRoute(builder: (context) => Courses())),
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
}
