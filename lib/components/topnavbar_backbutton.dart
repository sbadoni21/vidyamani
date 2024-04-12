import 'package:flutter/material.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomAppBarBckBtn extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final Function()? onWalletPressed;
  final Function()? onMenuPressed;
  final Function()? onBackPressed;

  const CustomAppBarBckBtn({
    Key? key,
    this.onWalletPressed,
    this.onMenuPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  _CustomAppBarBckBtnState createState() => _CustomAppBarBckBtnState();

  @override
  Size get preferredSize => Size.fromHeight(68);
}

class _CustomAppBarBckBtnState extends ConsumerState<CustomAppBarBckBtn> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () {
              _showWalletBottomSheet(context);
            },
            icon: Icon(Icons.wallet_outlined)),
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
              print("Back button pressed!");
              if (widget.onBackPressed != null) {
                widget.onBackPressed!();
              } else {
                print("Navigator.pop(context) called");
                Navigator.pop(context);
              }
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

  void _showWalletBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        User? user = ref.watch(userProvider);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: const LinearGradient(
                  colors: [bgColor, bgColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Current Balance :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user!.coins.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Add Money'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
