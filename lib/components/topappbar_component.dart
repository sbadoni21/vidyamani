import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidyamani/models/user_model.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/menu_screen.dart';
import 'package:vidyamani/utils/static.dart';


class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final Function()? onWalletPressed;
  final Function()? onMenuPressed;

  const CustomAppBar({
    Key? key,
    this.onWalletPressed,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _showWalletBottomSheet(context);
            },
            icon: const Icon(Icons.wallet_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            icon: const Icon(Icons.menu),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 34,
              child: Image.asset(
                "lib/assets/images/logowhite.png",
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              "Vidhyamani",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showWalletBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        User? user = ref.read(userProvider);

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
                  Image.asset(
                    'lib/assets/images/logowhite.png',
                    height: 100,
                    width: 100,
                  ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
