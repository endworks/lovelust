import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  final storage = const FlutterSecureStorage();
  bool authenticated = false;
  String? accessToken;

  Future<void> readAuthentication() async {
    accessToken = await storage.read(key: 'access_token');
    if (accessToken == null) {
      redirectToLogin();
    }
  }

  redirectToLogin() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) => const LoginPage());
  }

  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'Home', Icons.home_outlined, Icons.home, Colors.blue),
    Destination(
        1, 'Journal', Icons.assignment_outlined, Icons.assignment, Colors.red),
    Destination(
        2, 'Partners', Icons.group_outlined, Icons.group, Colors.indigo),
    Destination(3, 'Settings', Icons.settings_outlined, Icons.settings,
        Colors.blueGrey),
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<GlobalKey> destinationKeys;
  late final List<AnimationController> destinationFaders;
  late final List<Widget> destinationViews;
  int _selectedIndex = 0;

  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
    return controller;
  }

  @override
  void initState() {
    super.initState();
    readAuthentication();
    navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    destinationFaders = List<AnimationController>.generate(
        allDestinations.length, (int index) => buildFaderController()).toList();
    destinationFaders[_selectedIndex].value = 1.0;
    destinationViews = allDestinations.map((Destination destination) {
      return FadeTransition(
        opacity: destinationFaders[destination.index]
            .drive(CurveTween(curve: Curves.fastOutSlowIn)),
        child: DestinationView(
          destination: destination,
          navigatorKey: navigatorKeys[destination.index],
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final AnimationController controller in destinationFaders) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState navigator =
            navigatorKeys[_selectedIndex].currentState!;
        if (!navigator.canPop()) {
          return true;
        }
        navigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final int index = destination.index;
              final Widget view = destinationViews[index];
              if (index == _selectedIndex) {
                destinationFaders[index].forward();
                return Offstage(offstage: false, child: view);
              } else {
                destinationFaders[index].reverse();
                if (destinationFaders[index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: allDestinations.map((Destination destination) {
            return NavigationDestination(
              selectedIcon: Icon(destination.selectedIcon,
                  color: destination.color.shade400),
              icon: Icon(destination.icon),
              label: destination.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}
