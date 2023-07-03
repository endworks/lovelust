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
                backgroundColor: Theme.of(context).colorScheme.background,
                // surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 1,
                selectedIndex: selectedIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                destinations: <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.monitor_heart,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    icon: const Icon(Icons.monitor_heart_outlined),
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
            ));
  }
}
