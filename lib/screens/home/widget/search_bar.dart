import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../screen/search_details.dart';

class Searchbar extends StatelessWidget {
  final BuildContext context;

  const Searchbar({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            hintText: "Search products...",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () {
            String query = searchController.text.trim();
            if (query.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchDetailsScreen(query: query),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
