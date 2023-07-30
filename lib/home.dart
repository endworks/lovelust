import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/home/auth.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.initialLoadDone = false});

  final bool initialLoadDone;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with RestorationMixin, WidgetsBindingObserver {
  final SharedService _shared = getIt<SharedService>();
  final RestorableInt _selectedIndex = RestorableInt(0);
  bool _showDesktopNavigation = false;
  bool _centerDesktopNavigation = false;
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shared.addListener(updateSharedState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showDesktopNavigation =
        MediaQuery.of(context).orientation == Orientation.landscape;
    _centerDesktopNavigation = MediaQuery.of(context).size.height > 450;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint(state.toString());
    if (state == AppLifecycleState.inactive) {
      setState(() {
        _shared.authorized = false;
        _shared.updateWidgets();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shared.removeListener(updateSharedState);
    super.dispose();
  }

  void updateSharedState() {
    if (mounted) {
      setState(() {
        _authorized = _shared.authorized;
      });
    }
  }

  Widget get _selectedPage {
    return IndexedStack(
      index: _selectedIndex.value,
      children: const [
        // HomePage(),
        JournalPage(),
        PartnersPage(),
        SettingsPage(),
      ],
    );
  }

  List<Destination> get destinations {
    return [
      /*Destination(
        AppLocalizations.of(context)!.home,
        const Icon(Icons.monitor_heart_outlined),
        const Icon(
          Icons.monitor_heart,
        ),
      ),*/
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
              selectedIcon: destination.selectedIcon,
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
    if (widget.initialLoadDone) {
      if (_shared.requireAuth && !_authorized) {
        return const LocalAuthPage();
      } else {
        FlutterNativeSplash.remove();
      }
    }

    return Scaffold(
      body: _showDesktopNavigation
          ? Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _selectedIndex.value,
                  labelType: labelTypeFromTheme,
                  groupAlignment: _centerDesktopNavigation ? 0 : -1,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex.value = index;
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
              selectedIndex: _selectedIndex.value,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex.value = index;
                });
              },
              destinations: _navigationDestinations,
            )
          : null,
    );
  }

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'nav_bar_index');
  }
}
