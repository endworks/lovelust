import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/shared_service.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.initialLoadDone = false});

  final bool initialLoadDone;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SharedService _shared = getIt<SharedService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  int selectedIndex = 0;
  bool showNavigationDrawer = false;

  @override
  void initState() {
    super.initState();
    if (_shared.requireAuth) {
      _localAuth.init();
      _localAuth.getAvailableBiometrics();
      _localAuth.authenticate();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer =
        MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height;
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

  List<Destination> get destinations {
    return [
      Destination(
        AppLocalizations.of(context)!.journal,
        const Icon(Icons.assignment_outlined),
        const Icon(
          Icons.assignment,
        ),
      ),
      Destination(
        AppLocalizations.of(context)!.partners,
        const Icon(Icons.group_outlined),
        const Icon(
          Icons.group,
        ),
      ),
      Destination(
        AppLocalizations.of(context)!.settings,
        const Icon(Icons.settings_outlined),
        const Icon(
          Icons.settings,
        ),
      ),
    ];
  }

  List<Widget> get navigationDestinations {
    return destinations.map(
      (destination) {
        return NavigationDestination(
          label: destination.label,
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
        );
      },
    ).toList();
  }

  List<Widget> get drawerDestinations {
    return destinations.map(
      (destination) {
        return NavigationDrawerDestination(
          label: Text(destination.label),
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.initialLoadDone ||
        (_shared.requireAuth && !_localAuth.authorized)) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      key: _shared.scaffoldKey,
      body: selectedPage,
      bottomNavigationBar: !showNavigationDrawer
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              destinations: navigationDestinations,
            )
          : null,
      drawer: showNavigationDrawer
          ? NavigationDrawer(
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectedIndex: selectedIndex,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    'LoveLust',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...drawerDestinations,
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
                  child: Divider(),
                ),
              ],
            )
          : null,
    );
  }
}
