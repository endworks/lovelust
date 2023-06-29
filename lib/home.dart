import 'package:flutter/material.dart';
import 'package:lovelust/screens/home/home.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    /* common.initialLoad().whenComplete(() {
      setState(() {});
      if (common.isLoggedIn()) {
        common.initialFetch().whenComplete(() {
          setState(() {});          
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initial fetch successful')));
        });
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: common.initialLoad(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) => 
        Scaffold(
      body: <Widget>[
        const HomePage(),
        const JournalPage(),
        const PartnersPage(),
      ][selectedIndex],
      bottomNavigationBar: NavigationBar(
        elevation: null,
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
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
              Icons.group,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.group_outlined),
            label: 'Partners',
          ),
        ],
      ),
    )
  );}
}
