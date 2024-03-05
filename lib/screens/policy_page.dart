import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/utils/static.dart';

class PolicyPage extends StatelessWidget {
  PolicyPage({
    Key? key,
    required this.route,
  }) : super(key: key);

  final String route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarBckBtn(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Center(
              child: route == 'Privacy'
                  ? Lottie.asset(
                      "lib/assets/lottie/lockanimation.json",
                    )
                  : Lottie.asset('lib/assets/lottie/tandc.json'),
            ),
            Text(
              'Privacy Policy',
              style: myTextStylefontsize20BGCOLOR,
            ),
            SizedBox(
              height: 10,
            ),
            route == "Privacy"
                ? Text(
                    "Vidhyamani operates the portal in India, which offers educational contests and scholarships through its website and mobile application (collectively referred to as the “Portal”). Vidhyamani referred to herein as “Vidhyamani” or “we” or “us” “our”. Any person utilizing the Portal or any of its features including participation   in   the   various   contests,   games,   and   educational   scholarships      being conducted on the Portal shall be bound by the terms of this privacy policy (“Privacy Policy”). All capitalized terms not defined herein shall have the meaning ascribed to them in the Terms and Conditions. Vidhyamani respects the privacy of its Users and is committed to protecting it in all respects. With a view to offer an enriching and holistic internet experience to its Users, Vidhyamani offers a variety of educational contests and scholarships. Most of the Services are offered for free but you ma need registration to participate in the contests. The information about the User is collected by Vidhyamani as (i) information supplied by Users and (ii) information automatically tracked during User's navigation on Vidhyamani. Before   you   submit   any   information   to   the   Portal,   please   read   this   Privacy   Policy   for   an explanation of how we will treat your information. By using any part of the Portal, you consent to the collection, use, disclosure, and transfer of your information for the purposes outlined in this Privacy Policy and to the collection, processing, and maintenance of this information. Your use   of   any   part   of   the   Portal   indicates   your   acceptance   of   this   Privacy   Policy   and   of   the collection, use, and disclosure of your information in accordance with this Privacy Policy. While you have the option not to provide us with certain personal information, withdraw your consent to   collect   certain   information,   request   temporary   suspension   of   the   collection   of   personal information or request deletion of personal information collected, kindly note that in such an event you may not be able to take full advantage of the entire scope of features and services offered to you and we reserve the right not to provide you with our services. In the ever-evolving medium of the internet, Vidhyamani may periodically review and change our Privacy Policy to incorporate such future changes as may be considered appropriate. We will notify you of the change. Any changes to our Privacy Policy will be posted on this page, so you are always aware of what information we collect, how we use it, how we store it and under what circumstances we disclose it",
                    style: myTextStylefontsize12BGCOLOR,
                    textAlign: TextAlign.justify,
                  )
                : Text(
                    '''
These Terms and Conditions, and all other rules, regulations, and terms of use referred to herein or provided by Vidhyamani in relation to any Vidhyamani Services. Vidhyamani shall be entitled to modify these Terms and Conditions, rules, regulations, and terms of use referred to herein or provided by Vidhyamani in relation to any Vidhyamani Services, at any time, by posting the same on the Vidhyamani. Use of Vidhyamani constitutes the User's acceptance of such Terms and Conditions, rules, regulations, and terms of use referred to herein or provided by Vidhyamani in relation to any Vidhyamani Services, as may be amended from time to time. Vidhyamani may, at its sole discretion, also notify the User of any change or modification in these Terms and Conditions, rules, regulations, and terms of use referred to herein or provided by Vidhyamani.

Users agree to provide true, accurate, current, and complete information at the time of registration and at all other times (as required by Vidhyamani). Users further agree to update and keep updated their registration information.

Users are responsible for maintaining the confidentiality of their accounts and passwords. Users agree to immediately notify Vidhyamani of any unauthorized use of their accounts or any other breach of security.

Users agree to exit/log-out of their accounts at the end of each session. Vidhyamani shall not be responsible for any loss or damage that may result if the User fails to comply with these requirements.

Users agree not to use cheats, exploits, automation, software, bots, hacks, or any unauthorized third-party software designed to modify or interfere with Vidhyamani Services and/or Vidhyamani experience or assist in such activity.

Users shall not attempt to gain unauthorized access to the User accounts, servers or networks connected to Vidhyamani Services by any means other than the User interface provided by Vidhyamani, including but not limited to, by circumventing or modifying, attempting to circumvent or modify, or encouraging or assisting any other person to circumvent or modify, any security, technology, device, or software that underlies or is part of Vidhyamani Services.

Without limiting the foregoing, Users agree not to use the Vidhyamani for any of the following:
- To engage in any obscene, offensive, indecent, racial, communal, anti-national, objectionable, defamatory, or abusive action or communication.
- To harass, stalk, threaten, or otherwise violate any legal rights of other individuals.
- To disseminate any inappropriate, profane, defamatory, infringing, obscene, indecent, or unlawful content.
- To disseminate files that contain viruses, corrupted files, or any other similar software or programs that may damage or adversely affect the operation of another person's computer, Vidhyamani, any software, hardware, or telecommunications equipment.
- To download any file, recompile or disassemble or otherwise affect our products that you know or reasonably should know cannot be legally obtained in such manner.
- To falsify or delete any author attributions, legal or other proper notices or proprietary designations or labels of the origin or the source of software or other material.

Unauthorized access to the Vidhyamani is a breach of these Terms and Conditions, and a violation of the law. Users agree not to access the Vidhyamani by any means other than through the interface that is provided by Vidhyamani for use in accessing the Vidhyamani. Users agree not to use any automated means, including, without limitation, agents, robots, scripts, or spiders, to access, monitor, or copy any part of our sites, except those automated means that we have approved in advance and in writing.

Use of the Vidhyamani is subject to existing laws and legal processes. Nothing contained in these Terms and Conditions shall limit Vidhyamani's right to comply with governmental, court, and law-enforcement requests or requirements relating to Users' use of the Vidhyamani.

Users may reach out to Vidhyamani through - Helpdesk if the User has any concerns regarding an education contest and/or Contest within Forty-Eight (48) hours of winner declaration for the concerned Contest.

User hereby confirms that he / she is participating in a Contest in personal capacity and not during business and /or profession.

Conditions of Participation:
By entering a Contest, User agrees to be bound by these Terms and Conditions and the decisions of Vidhyamani. Subject to the terms and conditions stipulated herein below, Vidhyamani, at its sole discretion, may disqualify any User from a Contest, refuse to award benefits or Rewards and require the return of any Rewards, if the User engages in unfair conduct, which Vidhyamani deems to be improper, unfair or otherwise adverse to the operation of the Contest or is in any way detrimental to other Users which includes, but is not limited to:
- Falsifying one's own personal information (including, but not limited to, name, email address, bank account details and/or any other information or documentation as may be requested by Vidhyamani to enter a Contest and/or claim a Reward/winning).
- Engaging in any type of financial fraud or misrepresentation including unauthorized use of credit/debit instruments, payment wallet accounts etc. to enter a Contest or claim a Reward.
- Any violation of Contest rules, these Terms and Conditions, or the Terms of Use, as specified.
- Accumulating points or Rewards through unauthorized methods such as automated bots, or other automated means.
- Using automated means (including but not limited to harvesting bots, robots, parser, spiders, or screen scrapers) to obtain, collect or access any information on the Vidhyamani or of any User for any purpose.
- Any type of Cash Bonus misuse; tampering with the administration of a Contest or trying to in any way tamper with the computer programs or any security measure associated with a Contest.
- Obtaining other Users' information without their express consent and/or knowledge and/or spamming other Users (Spamming may include but shall not be limited to send unsolicited emails to Users, sending bulk emails to Users, sending unwarranted email content either to selected Users or in bulk); or
- Abusing the Vidhyamani in any way ('unparliamentary language, slangs or disrespectful words' are some of the examples of Abuse).
It is clarified that in case a User is found to be in violation of this policy, Vidhyamani reserves its right to initiate appropriate civil/criminal remedies as it may be advised other than forfeiture and/or recovery of Reward money if any.

1. Any winning educational contest or reward can be transferred to your respected nominated person.
2. Winning reward or educational scholarship can be used for educational purpose or your technical skills or career related courses only. Educational scholarship or rewards cannot be redeemed in cash or digital money.
3. Our mission is to make our country educated in their skills and talent we want to promote education with the help of Vidhyamani educational contest services so that it can be easier for everyone to help them and their kids, siblings and relatives for their wonderful future growth
  ''',
                    style: myTextStylefontsize12BGCOLOR,
                    textAlign: TextAlign.justify,
                  ),
          ]),
        ));
  }
}
