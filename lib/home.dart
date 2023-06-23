import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/screens/home/home.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const HomePage(),
        const JournalPage(),
        const PartnersPage(),
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.favorite_border),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.assignment,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.assignment_outlined),
            label: 'Journal',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.person_outlined),
            label: 'Partners',
          ),
        ],
      ),
    );
  }
}
