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
  int _selectedIndex = 0;
  bool _showDesktopNavigation = false;
  bool _centerDesktopNavigation = false;

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
    _showDesktopNavigation =
        MediaQuery.of(context).orientation == Orientation.landscape;
    _centerDesktopNavigation = MediaQuery.of(context).size.height > 450;
  }

  Widget get _selectedPage {
    if (_selectedIndex > -1) {
      return pages[_selectedIndex];
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

  List<NavigationDestination> get _navigationDestinations {
    return destinations
        .map((destination) => NavigationDestination(
              label: destination.label,
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            ))
        .toList();
  }

  List<NavigationRailDestination> get _navigationRailDestinations {
    return destinations
        .map((destination) => NavigationRailDestination(
              icon: destination.icon,
              selectedIcon: destination.icon,
              label: Text(destination.label),
            ))
        .toList();
  }

  NavigationRailLabelType get labelTypeFromTheme {
    NavigationDestinationLabelBehavior? labelBehavior =
        Theme.of(context).navigationBarTheme.labelBehavior;
    if (labelBehavior == NavigationDestinationLabelBehavior.alwaysHide) {
      return NavigationRailLabelType.none;
    } else if (labelBehavior ==
        NavigationDestinationLabelBehavior.onlyShowSelected) {
      return NavigationRailLabelType.selected;
    } else {
      return NavigationRailLabelType.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.initialLoadDone) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      body: _showDesktopNavigation
          ? Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  labelType: labelTypeFromTheme,
                  groupAlignment: _centerDesktopNavigation ? 0 : -1,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: _navigationRailDestinations,
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: _selectedPage,
                ),
              ],
            )
          : _selectedPage,
      bottomNavigationBar: !_showDesktopNavigation
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _navigationDestinations,
            )
          : null,
    );
  }
}
