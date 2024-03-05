import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/screens/developedby_page.dart';
import 'package:vidyamani/screens/policy_page.dart';
import 'package:vidyamani/utils/static.dart';

Future<void> launchUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

Future<void> _launchEmail(String emailAddress) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );
  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri.toString());
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

class InfoSection {
  final String title;
  final String content;
  final String dropdownContent;

  InfoSection(this.title, this.content, this.dropdownContent);
}

class AboutAppPage extends StatelessWidget {
  final String websiteUrl = "https://www.vidhyamani.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/logo.png'),
            Text('About Vidhyamani app', style: myTextStylefontsize16),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: myTextStylefontsize16,
                ),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(websiteUrl);
                  },
                  child: Text(
                    websiteUrl,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Website',
                  style: myTextStylefontsize16,
                ),
                GestureDetector(
                  onTap: () async {
                    await _launchEmail(websiteUrl);
                  },
                  child: Text(
                    websiteUrl,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                  elevation: MaterialStatePropertyAll(10),
                  enableFeedback: true,
                  animationDuration: Durations.medium3),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyPage(route: 'Privacy')));
              },
              child: Text("Privacy Policy"),
            ),
            TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    elevation: MaterialStatePropertyAll(10),
                    enableFeedback: true,
                    animationDuration: Durations.medium3),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PolicyPage(route: 'TandC')));
                },
                child: Text("Terms and Conditions")),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                  elevation: MaterialStatePropertyAll(10),
                  enableFeedback: true,
                  animationDuration: Durations.medium3),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Digital360Page()));
              },
              child: Text("Developed by"),
            ),
          ],
        ),
      ),
    );
  }
}
