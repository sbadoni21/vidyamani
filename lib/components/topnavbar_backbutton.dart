import 'package:flutter/material.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:vidyamani/utils/static.dart';

class CustomAppBarBckBtn extends StatelessWidget
    implements PreferredSizeWidget {
  final Function()? onWalletPressed;
  final Function()? onMenuPressed;

  const CustomAppBarBckBtn({
    Key? key,
    this.onWalletPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.wallet_outlined)),
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuScreen()));
          },
          icon: Icon(Icons.menu),
        ),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 18,
            ),
          ),
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
