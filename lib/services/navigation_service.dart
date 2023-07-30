import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Route<Widget> route) {
    return navigatorKey.currentState!.push(route);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
