import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:logger/logger.dart';

class HomePage extends StatelessWidget {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (widget.zoomDrawerController != null) {
                widget.zoomDrawerController!.toggle!();
              }
            },
            icon: Icon(Icons.menu),
          ),
          centerTitle: true,
          title: Image.asset(
            "lib/assets/images/logo.jpg",
            height: 50,
            width: 50,
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                viewportFraction: 1,
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
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Main Content',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
