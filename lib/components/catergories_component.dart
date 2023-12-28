import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final MaterialPageRoute pageRoute;

  const CategoryItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.pageRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context, pageRoute);
      },
      style: OutlinedButton.styleFrom(
        fixedSize: Size(100, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
