import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class CustomListTile extends StatelessWidget {
  final String imgUrl;
  final String text1;
  final String text2;
  final VoidCallback onPressed;

  const CustomListTile({
    Key? key,
    required this.imgUrl,
    required this.text1,
    required this.text2,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          child: Image.asset(
        imgUrl,
        width: 60,
        height: 60,
      )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: bgColor),
          ),
          Text(
            text2,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert), // Replace with your desired icon
        onPressed: onPressed,
      ),
    );
  }
}
