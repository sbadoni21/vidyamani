import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/components/topappbar_component.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/utils/static.dart';

Future<void> launchUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class Digital360Page extends StatelessWidget {
  final String websiteUrl = "https://www.vidhyamani.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: ListView(
          children: [
            Image.asset('lib/assets/images/companylogo.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Developed with ",
                  style: myTextStylefontsize16,
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
                Text(
                  " by Digital360India",
                  style: myTextStylefontsize16,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "App Developers",
                  style: myTextStylefontsize14,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Shivam Badoni",
                      style: myTextStylefontsize14,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "Shivang Rawat",
                      style: myTextStylefontsize14,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Backend Developers",
                  style: myTextStylefontsize14,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Himanshi Rawat",
                      style: myTextStylefontsize14,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
