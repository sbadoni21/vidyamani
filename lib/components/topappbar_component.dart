import 'package:flutter/material.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:vidyamani/utils/static.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onWalletPressed;
  final Function()? onMenuPressed;

  const CustomAppBar({
    Key? key,
    this.onWalletPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.wallet_outlined)),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MenuScreen()));
            },
            icon: Icon(Icons.menu),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 34,
              child: Image.asset(
                "lib/assets/images/logowhite.png",
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Vidhyamani",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
