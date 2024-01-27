import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class AdRewardPopup extends StatelessWidget {
  final num rewardpoints;
  AdRewardPopup({required this.rewardpoints});

  @override
  Widget build(BuildContext context) {
    double width = double.infinity - 60;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.infinity - 60,
        height: width,
        child: Column(
          children: [
            Image.asset(
              imageStatic,
              width: 250,
              height: 250,
            ),
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
            Text('You earned $rewardpoints Coins'),
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
