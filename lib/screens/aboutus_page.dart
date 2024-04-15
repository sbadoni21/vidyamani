import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/detailed_aboutuspage.dart';
import 'package:vidyamani/screens/developedby_page.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/policy_page.dart';
import 'package:vidyamani/screens/splashscreen.dart';
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

class AboutAppPage extends ConsumerStatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends ConsumerState<AboutAppPage> {
  final String websiteUrl = "https://www.vidhyamani.com";

  @override
  Widget build(BuildContext context) {
        User? user = ref.watch(userStateNotifierProvider);
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: ListView(
          children: [
            Image.asset('lib/assets/images/logo.png'),
            Center(
              child: Text(
                  '"Your personalised E-learning platform igniting curosity and cultivating potential" ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellowAccent[700],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedAboutUsPage()));
                },
                child:
                    Text('About Vidhyamani app', style: myTextStylefontsize16)),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    elevation: MaterialStateProperty.all(10),
                    enableFeedback: true,
                    animationDuration: Durations.medium3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PolicyPage(route: 'Privacy'),
                      ),
                    );
                  },
                  child: Text("Privacy Policy"),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    elevation: MaterialStateProperty.all(10),
                    enableFeedback: true,
                    animationDuration: Durations.medium3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PolicyPage(route: 'TandC'),
                      ),
                    );
                  },
                  child: Text("Terms and Conditions"),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    elevation: MaterialStateProperty.all(10),
                    enableFeedback: true,
                    animationDuration: Durations.medium3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Digital360Page(),
                      ),
                    );
                  },
                  child: Text("Developed by"),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Colors.blue,
                        ),
                        elevation: MaterialStateProperty.all(10),
                        enableFeedback: true,
                        animationDuration: Durations.medium3,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure ?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('This will delete your account.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(
                                            userStateNotifierProvider.notifier)
                                        .deleteUser(userId: user!.uid);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SplashScreen()));
                                  },
                                  child: Text('Approve'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Delete your account"),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
