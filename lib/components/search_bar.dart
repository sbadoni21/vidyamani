import 'package:flutter/material.dart';
import 'package:vidyamani/utils/static.dart';

class SearchBarsection extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  SearchBarsection({this.onSearch});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double barWidth = 290; 

    return Row(
      children: [
        SearchBar(barWidth: barWidth, onChanged: onSearch),
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
  final ValueChanged<String>? onChanged;

  const SearchBar({required this.barWidth, this.onChanged});

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
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: bgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
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
