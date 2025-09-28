import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'breeding_screen.dart';
import 'fattening_screen.dart'; // Import the new screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Breeding and Fattening
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PorciApp'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/settings'); // Navigate to settings
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'CRIANZA', icon: Icon(Icons.child_friendly)),
              Tab(text: 'ENGORDA', icon: Icon(Icons.ramen_dining)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BreedingScreen(),
            FatteningScreen(), // Connect the FatteningScreen
          ],
        ),
      ),
    );
  }
}
