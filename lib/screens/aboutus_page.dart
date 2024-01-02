import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/screens/contact_page.dart';
import 'package:vidyamani/utils/static.dart';

class InfoSection {
  final String title;
  final String content;
  final String dropdownContent;

  InfoSection(this.title, this.content, this.dropdownContent);
}

class AboutAppPage extends StatelessWidget {
  final List<InfoSection> infoSections = [
    InfoSection('Version', '1.23.32.35', ''),
    InfoSection('Email', 'vidhyamaniedu@gmail.com', ''),
    InfoSection('Website', 'www.vidhyamani.com', ''),
    InfoSection(
      'About Us',
      'Vidhyamani is a platform for education and learning...',
      'Mission\nVision\nValues',
    ),
    InfoSection('Reward Coin', 'How to get Reward Coins', ''),
    InfoSection('Terms of Service', '', ''),
    InfoSection('Privacy Policy', '', ''),
    InfoSection('GDPR Law', '', ''),
    InfoSection('Copyright', '', ''),
    InfoSection('Design and Developed', '', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBckBtn(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        child: ListView(
          children: [
            Text('About Vidhyamani app', style: myTextStylefontsize16),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: infoSections.length,
              itemBuilder: (context, index) {
                final section = infoSections[index];

                return ExpansionTile(
                  iconColor: bgColor,
                  textColor: bgColor,
                  initiallyExpanded: false,
                  collapsedIconColor: bgColor,
                  title: Text(
                    section.title,
                    style: myTextStylefontsize16,
                  ),
                  children: [
                    if (section.content.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              section.content,
                              style: myTextStylefontsize16,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    if (section.dropdownContent.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            section.dropdownContent,
                            style: myTextStylefontsize16,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
