import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/screens/packagepayment_page.dart';
import 'package:vidyamani/utils/static.dart';

class BuyPlans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PackagePaymentPage(packageName: 'Gold'),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cardColor,
                ),
                width: double.infinity,
                height: 250,
                child: Stack(
                  children: [
                    Positioned(right: 0, child: Image.asset(logohalf)),
                    Positioned(
                        left: 20,
                        top: 36,
                        child: Text(
                          'Vidhyamani Plus',
                          style: myTextStylefontsize24BGCOLOR,
                        )),
                    Positioned(
                        left: 20,
                        top: 102,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                            Text(
                              'Ad-free Content',
                              style: myTextStylefontsize16,
                            ),
                          ],
                        )),
                    Positioned(
                        left: 20,
                        top: 168,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "₹",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "***",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "/",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "month",
                              style: myTextStylefontsize14,
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: bgColor,
                ),
                width: double.infinity,
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                        right: 0,
                        child: Image.asset(
                          logohalf,
                          color: cardColor,
                        )),
                    Positioned(
                        left: 20,
                        top: 36,
                        child: Text(
                          'Vidhyamani Premium',
                          style: myTextStylefontsize24,
                        )),
                    Positioned(
                        left: 20,
                        top: 85,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                            Text(
                              'Ad-free Content',
                              style: myTextStylefontsize16white,
                            ),
                          ],
                        )),
                    Positioned(
                        left: 20,
                        top: 110,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                            Text(
                              'Advanced Courses',
                              style: myTextStylefontsize16white,
                            ),
                          ],
                        )),
                    Positioned(
                        left: 20,
                        top: 135,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Premium  Content  (Competitive  exam ',
                                  style: myTextStylefontsize16white,
                                ),
                                Text(
                                  'content etc.)',
                                  style: myTextStylefontsize16white,
                                ),
                              ],
                            )
                          ],
                        )),
                    Positioned(
                        left: 20,
                        top: 168,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "₹",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "***",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "/",
                              style: myTextStylefontsize24BGCOLOR,
                            ),
                            Text(
                              "month",
                              style: myTextStylefontsize14,
                            )
                          ],
                        )),
                    Positioned(
                        left: 20,
                        top: 194,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "₹",
                              style: myTextStylefontsize24,
                            ),
                            Text(
                              "***",
                              style: myTextStylefontsize24,
                            ),
                            Text(
                              "/",
                              style: myTextStylefontsize24,
                            ),
                            Text(
                              "month",
                              style: myTextStylefontsize14White,
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
