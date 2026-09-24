import 'package:flutter/material.dart';

class MenuSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String queryText;
  
  final Function(String) onSearch; 
  final Function() onClear;

  const MenuSearchBar({
    super.key,
    required this.controller,
    required this.queryText,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Cari menu...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: queryText.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                ),
          border: const OutlineInputBorder(),
        ),
        onChanged: onSearch,
      ),
    );
  }
}