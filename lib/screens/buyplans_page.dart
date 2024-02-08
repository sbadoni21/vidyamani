import 'package:flutter/material.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/package_model.dart';
import 'package:vidyamani/screens/phonepay_payment.dart';
import 'package:vidyamani/services/data/miscellaneous_services.dart';
import 'package:vidyamani/utils/static.dart';

class BuyPlans extends StatefulWidget {
  const BuyPlans({Key? key}) : super(key: key);

  @override
  State<BuyPlans> createState() => _BuyPlansState();
}

class _BuyPlansState extends State<BuyPlans> {
  late Future<Packages> packages;

  @override
  void initState() {
    super.initState();
    packages = fetchPackagePrices();
  }

  Future<Packages> fetchPackagePrices() async {
    try {
      Packages? packages = await MiscellaneousService().fetchPackagePrices();
      return packages ?? Packages(goldPackagePrice: 0, premiumPackagePrice: 0);
    } catch (e) {
      print('Error fetching package prices: $e');
      return Packages(goldPackagePrice: 0, premiumPackagePrice: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: FutureBuilder<Packages>(
        future: packages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            Packages fetchedPackages = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhonePayPayment(
                            packageType: "gold",
                            packages: fetchedPackages,
                          ),
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
                            ),
                          ),
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
                            ),
                          ),
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
                                  "${fetchedPackages.goldPackagePrice}",
                                  style: myTextStylefontsize24BGCOLOR,
                                ),
                                Text(
                                  "/",
                                  style: myTextStylefontsize24BGCOLOR,
                                ),
                                Text(
                                  "month",
                                  style: myTextStylefontsize14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  PhonePayPayment(
                            packageType: "premium",
                            packages: fetchedPackages,
                          ),
                        ),
                      );
                    },
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
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 36,
                            child: Text(
                              'Vidhyamani Premium',
                              style: myTextStylefontsize24,
                            ),
                          ),
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
                            ),
                          ),
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
                            ),
                          ),
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
                                      'Premium Content (Competitive exam ',
                                      style: myTextStylefontsize16white,
                                    ),
                                    Text(
                                      'content etc.)',
                                      style: myTextStylefontsize16white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                                  "${fetchedPackages.premiumPackagePrice}",
                                  style: myTextStylefontsize24,
                                ),
                                Text(
                                  "/",
                                  style: myTextStylefontsize24,
                                ),
                                Text(
                                  "month",
                                  style: myTextStylefontsize14White,
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
