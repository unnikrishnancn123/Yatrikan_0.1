import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/pages/home/bloc/home_event.dart';

import '../bloc/home_bloc.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ' Search By Location'; // Holds the current search query

  void _performSearch(String query) {
    context.read<HomeBloc>().add(FetchDataEvent( query: query));
    setState(() {
      _searchQuery = query;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                  borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.sort_rounded, size: 28),
            ),
          ), Center(
         child: Expanded(
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFF65959)),
                const SizedBox(width: 5),
                Text(
                    _searchQuery,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Search Location'),
                    content: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Enter location...',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _performSearch(_searchController.text);
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                  borderRadius: BorderRadius.circular(15)),
              child: const Icon(
                Icons.search,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
