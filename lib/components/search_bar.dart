import 'package:flutter/material.dart';

class SearchBarWithButton extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(75.00);
  final String hintText;

  const SearchBarWithButton({super.key, required this.hintText});

  @override
  State<SearchBarWithButton> createState() => _SearchBarWithButtonState();
}

class _SearchBarWithButtonState extends State<SearchBarWithButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SearchBar(
        trailing: [
          const Icon(
            Icons.search,
            color: Colors.blueAccent,
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_voice,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              print('Use voice command');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              print('Use image search');
            },
          ),
        ],
        hintText: widget.hintText,
        hintStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(MaterialState.disabled)
                ? Colors.indigo.shade700.withOpacity(
                    0.5) // Adjust the disabled hint color if needed
                : Colors.indigo.shade700, // Set the hint text color to black
          ),
        ),
      ),
    );
  }
}
