import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/login.dart';

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
    Destination(0, 'Activity', Icons.favorite_border_outlined, Icons.favorite,
        Colors.red),
    Destination(
        1, 'Partners', Icons.group_outlined, Icons.group, Colors.purple),
    Destination(2, 'Stats', Icons.monitor_heart_outlined, Icons.monitor_heart,
        Colors.cyan),
    Destination(3, 'Learn', Icons.book_outlined, Icons.book, Colors.orange),
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
              selectedIcon:
                  Icon(destination.selectedIcon, color: destination.color),
              icon: Icon(destination.icon, color: destination.color),
              label: destination.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}
