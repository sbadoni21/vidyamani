import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/utils/static.dart';

class DetailedAboutUsPage extends StatelessWidget {
  const DetailedAboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: ListView(
        children: [
          buildCards("Vision",
              "To become the best e-learning platform fostering passionate knowledge seekers and make high-quality education accessible to everyone. "),
          buildCards("Mission",
              "To  empower  learners  of  all  backgrounds  through  free,  online,  transformative  skill-based  courses and engaging academic courses and also allowing learners to earn while they learn."),
          buildCards("About Us",
              "VIDHYAMANI, where learning goes beyond textbooks and classrooms! We are a vibrant community and more than just an e-learning platform. We craft exceptional online courses to cater diverse minds and interests. Our team of educators believe that learning should be an empowering and enriching experience. Apart from our e-learning platform, focussed and determined minds can explore our course library, connect with our community and embark on a life changing experience with us! "),
          buildCards("What makes us unique?",
              "Immersive experience and quality education:\n Our courses are curated and taught by experts  who  bring  their  knowledge  and  wisdom  with  captivating  video  lectures (academic and skill-based), audio-books, animated books and interactive book reviews.\n • Learn at Your Pace: \n • Learn on your terms, dive into a topic of your choice and personalize your learning.\n • Passive Income Source: learners can earn while learning and transform their career journey."),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Text(
                "Let’s start with your metamorphosis journey with Vidhyamani today!",
                style: myTextStylefontsize14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCards(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        shadowColor: bgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: myTextStylefontsize20BGCOLOR,
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: bgColor,
              ),
              Text(
                content,
                style: myTextStylefontsize12Black,
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
