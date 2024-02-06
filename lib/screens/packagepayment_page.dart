import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/components/topnavbar_backbutton.dart';
import 'package:vidyamani/models/coins_model.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/services/data/coins_service.dart';
import 'package:vidyamani/services/data/subscription_service.dart';
import 'package:vidyamani/utils/static.dart';

final userProvider = Provider<User?>((ref) {
  return ref.watch(userStateNotifierProvider);
});

class PackagePaymentPage extends ConsumerStatefulWidget {
  final String packageName;

  PackagePaymentPage({required this.packageName});
  @override
  PackagePaymentPageState createState() => PackagePaymentPageState();
}

class PackagePaymentPageState extends ConsumerState<PackagePaymentPage> {
  User? user;
  CoinsService coinsService = CoinsService();
  Coins? coins;
  Coins? coin;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    getcoins();
  }

  Future<void> getcoins() async {
    try {
      coins = await coinsService.getCoinsData();
      setState(() {
        coin = coins;
        isLoading = false;
      });
    } catch (e) {
      print("Error in getcoins: $e");
      setState(() {
        isLoading = false;
        error = "Error fetching data. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarBckBtn(),
      body: widget.packageName == "Gold"
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : error != null
                      ? Center(
                          child: Text(
                            error!,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: cardColor,
                                ),
                                width: double.infinity,
                                height: 250,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        right: 0, child: Image.asset(logohalf)),
                                    Positioned(
                                      left: 20,
                                      top: 36,
                                      child: Text(
                                        'Vidhyamani Gold',
                                        style: myTextStylefontsize24BGCOLOR,
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 102,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Coins Required : ',
                                            style: myTextStylefontsize16,
                                          ),
                                          Text(
                                            '${coin?.coinsForGold}',
                                            style: myTextStylefontsize16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 124,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Coins Available : ',
                                            style: myTextStylefontsize16,
                                          ),
                                          Text(
                                            '${user?.coins}',
                                            style: myTextStylefontsize16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 168,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "₹",
                                            style: myTextStylefontsize24BGCOLOR,
                                          ),
                                          Text(
                                            '${coin!.rupeesForGold}',
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
                            const SizedBox(height: 20),
                            if (user!.coins >= coin!.coinsForGold)
                              ElevatedButton(
                                onPressed: () {
                                  SubscriptionService()
                                      .changeUserTypeViaCoinToGold(user!.uid);
                                },
                                child: Text("Pay with Coins"),
                              ),
                          ],
                        ),
            )
          : SizedBox(),
    );
  }
}
