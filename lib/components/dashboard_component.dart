import 'package:flutter/material.dart';
import 'package:vidyamani/screens/courses_page.dart';
import 'package:vidyamani/screens/history_page.dart';
import 'package:vidyamani/screens/saved_courses.dart';
import 'package:vidyamani/screens/upcoming_page.dart';
import 'package:vidyamani/utils/static.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedQueryIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final queries = [
    {
      'Query': 'MATH Chapter - 1',
      'progress': 0.7,
    },
    {
      'Query': 'Science Quiz',
      'progress': 0.5,
    },
    {
      'Query': 'History Assignment',
      'progress': 0.9,
    },
    {
      'Query': 'History Assignment',
      'progress': 0.9,
    },
  ];

  Widget buildCoursesPage() {
    // Implement your Courses page UI here
    return CoursesPage();
  }

  Widget buildSavedPage() {
    // Implement your Saved page UI here
    return SavedPage();
  }

  Widget buildUpcomingPage() {
    // Implement your Upcoming page UI here
    return UpcomingPage();
  }

  Widget buildHistoryPage() {
    // Implement your History page UI here
    return HistoryPage();
  }

  Widget buildQueryPage(int index) {
    switch (index) {
      case 0:
        return buildCoursesPage();
      case 1:
        return buildSavedPage();
      case 2:
        return buildUpcomingPage();
      case 3:
        return buildHistoryPage();
      default:
        return Container(); // Return an empty container for an unknown index
    }
  }

  ElevatedButton buildQueryButton(String text, int index, IconData icon) {
    final isActive = selectedQueryIndex == index;
    final textcolor = isActive ? Colors.white : bgColor;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? bgColor : Colors.white,
        elevation: isActive ? 2 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedQueryIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            color: textcolor,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: textcolor),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                buildQueryButton("Courses", 0, Icons.computer_sharp),
                buildQueryButton("Saved", 1, Icons.bookmark_border_outlined),
                buildQueryButton("Upcoming", 2, Icons.lightbulb),
                buildQueryButton("History", 3, Icons.lock_clock),
              ],
            ),
          ),
          SizedBox(
            height: 800,
            child: PageView.builder(
              itemCount: queries.length,
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  selectedQueryIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return buildQueryPage(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
