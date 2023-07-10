import 'package:flutter/material.dart';
import 'package:lovelust/screens/home/home.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget get selectedPage {
    if (selectedIndex > -1) {
      return pages[selectedIndex];
    }
    return const Text('loading');
  }

  List<Widget> get pages {
    return [
      const HomePage(),
      const JournalPage(),
      const PartnersPage(),
    ];
  }

  List<Widget> get destinations {
    return [
      const NavigationDestination(
        selectedIcon: Icon(
          Icons.monitor_heart,
        ),
        icon: Icon(Icons.monitor_heart_outlined),
        label: 'Home',
      ),
      const NavigationDestination(
        selectedIcon: Icon(
          Icons.assignment,
        ),
        icon: Icon(Icons.assignment_outlined),
        label: 'Journal',
      ),
      const NavigationDestination(
        selectedIcon: Icon(
          Icons.group,
        ),
        icon: Icon(Icons.group_outlined),
        label: 'Partners',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }
}
