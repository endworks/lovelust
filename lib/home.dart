import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/home/home.dart';
import 'package:lovelust/screens/home/protected.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/partners/partners.dart';
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
  bool _protected = false;
  bool _showDesktopNavigation = false;
  bool _centerDesktopNavigation = false;

  @override
  void initState() {
    super.initState();
    _protected = _shared.protected;
    WidgetsBinding.instance.addObserver(this);
    _shared.addListener(updateSharedState);
    HomeWidget.widgetClicked.listen(_shared.launchedFromWidget);
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
    _shared.appLifecycleStateChanged(state);
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
        _protected = _shared.protected;
      });
    }
  }

  Widget get _selectedPage {
    return IndexedStack(
      index: _selectedIndex.value,
      children: const [
        HomePage(),
        JournalPage(),
        PartnersPage(),
      ],
    );
  }

  List<Destination> get destinations {
    return [
      Destination(
        AppLocalizations.of(context)!.home,
        const Icon(Icons.favorite_border),
        const Icon(
          Icons.favorite,
        ),
      ),
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
      /*Destination(
        AppLocalizations.of(context)!.learn,
        const Icon(Icons.book_outlined),
        const Icon(
          Icons.book,
        ),
      ),*/
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
    List<Widget> stacked = [];

    stacked.add(
      Scaffold(
        extendBody: !_shared.material,
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
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: !_shared.material
                            ? Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(204)
                            : Theme.of(context).colorScheme.surface,
                        child: NavigationBar(
                          selectedIndex: _selectedIndex.value,
                          onDestinationSelected: (int index) {
                            setState(() {
                              _selectedIndex.value = index;
                            });
                          },
                          destinations: _navigationDestinations,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );

    if (widget.initialLoadDone) {
      if (_protected) {
        stacked.add(const ProtectedPage());
      } else {
        FlutterNativeSplash.remove();
      }
    }

    return Stack(
      children: stacked,
    );
  }

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'nav_bar_index');
  }
}
