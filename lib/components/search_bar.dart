import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class SearchBarsection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = (290); // Divide by the number of bars

    return Row(
      children: [
        SearchBar(barWidth: barWidth),
        SizedBox(
          width: 25,
        ),
        Container(
          width: 44,
          height: 44,
          color: Color.fromRGBO(240, 243, 248, 1),
          child: Icon(
            Icons.filter_alt_outlined,
            size: 32,
            color: bgColor,
          ),
        )
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final double barWidth;

  const SearchBar({required this.barWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: barWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 243, 248, 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enableSuggestions: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: bgColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Icon(
              Icons.search,
              color: bgColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
