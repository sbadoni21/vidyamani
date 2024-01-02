import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';


Future<void> launchUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class ContactUsPage extends StatelessWidget {
  final String websiteUrl = "https://www.vidhyamani.com";
  final List<String> emailAddresses = [
    "vidhyamaniedu@gmail.com",
    "vidhyamani.cust.care@gmail.com",
    "customercare@vidhyamani.com",
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 26,
            ),
            const Text(
              'You can Contact us through our Website:',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            const Text(
              'Or drop a mail at:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: emailAddresses
                  .map(
                    (email) => GestureDetector(
                      onTap: () async {
                        await _launchEmail(email);
                      },
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
