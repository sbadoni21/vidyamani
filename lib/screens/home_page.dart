import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vidyamani/components/categories_component.dart';
import 'package:vidyamani/components/circular_tiles_component.dart';
import 'package:vidyamani/components/featured_courses_component.dart';
import 'package:vidyamani/components/heading_component.dart';
import 'package:vidyamani/screens/courses_page.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/utils/static.dart';

class HomePage extends StatelessWidget {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      mainScreenTapClose: true,
      controller: zoomDrawerController,
      menuScreen: MenuScreen(
        zoomDrawerController: zoomDrawerController,
      ),
      mainScreen: MainScreen(zoomDrawerController: zoomDrawerController),
      borderRadius: 24.0,
      menuBackgroundColor: Colors.blue,
      showShadow: true,
      angle: 0,
      drawerShadowsBackgroundColor: Colors.blue,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}

class MainScreen extends StatefulWidget {
  final ZoomDrawerController? zoomDrawerController;
  const MainScreen({Key? key, this.zoomDrawerController}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.wallet_outlined)),
          IconButton(
            onPressed: () {
              if (widget.zoomDrawerController != null) {
                widget.zoomDrawerController!.toggle!();
              }
            },
            icon: Icon(Icons.menu),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 34,
              child: Image.asset(
                "lib/assets/images/logowhite.png",
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Vidhyamani",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
