import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/shared_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SharedService _shared = getIt<SharedService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (_shared.requireAuth) {
      _localAuth.init();
      _localAuth.getAvailableBiometrics();
      _localAuth.authenticate();
    }
  }

  Widget get selectedPage {
    if (selectedIndex > -1) {
      return pages[selectedIndex];
    }
    return const Text('loading');
  }

  List<Widget> get pages {
    return [
      // const HomePage(),
      const JournalPage(),
      const PartnersPage(),
      const SettingsPage(),
    ];
  }

  List<Widget> get destinations {
    return [
      /*NavigationDestination(
        selectedIcon: const Icon(
          Icons.monitor_heart,
        ),
        icon: const Icon(Icons.monitor_heart_outlined),
        label: AppLocalizations.of(context)!.home,
      ),*/
      NavigationDestination(
        selectedIcon: const Icon(
          Icons.assignment,
        ),
        icon: const Icon(Icons.assignment_outlined),
        label: AppLocalizations.of(context)!.journal,
      ),
      NavigationDestination(
        selectedIcon: const Icon(
          Icons.group,
        ),
        icon: const Icon(Icons.group_outlined),
        label: AppLocalizations.of(context)!.partners,
      ),
      NavigationDestination(
        selectedIcon: const Icon(
          Icons.settings,
        ),
        icon: const Icon(Icons.settings_outlined),
        label: AppLocalizations.of(context)!.settings,
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
