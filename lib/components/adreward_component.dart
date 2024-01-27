import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:lottie/lottie.dart';

class AdRewardPopup extends StatelessWidget {
  final num rewardpoints;
  AdRewardPopup({required this.rewardpoints});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.infinity - 80,
        height: 350,
        child: Column(
          children: [
            Container(
                height: 200,
                width: 200,
                child: LottieBuilder.asset(coinsLottie)),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Congratulations.....',
              style: myTextStylefontsize24BGCOLOR,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'You earned $rewardpoints Coins',
              style: myTextStylefontsize14,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
