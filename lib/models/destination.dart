import 'package:flutter/material.dart';
import 'package:lovelust/screens/home/home.dart';
import 'package:lovelust/screens/journal/journal.dart';
import 'package:lovelust/screens/login/login.dart';
import 'package:lovelust/screens/partners/partners.dart';
import 'package:lovelust/screens/settings/settings.dart';

class Destination {
  const Destination(
      this.index, this.title, this.icon, this.selectedIcon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final MaterialColor color;
}

class DestinationView extends StatefulWidget {
  const DestinationView({
    super.key,
    required this.destination,
    required this.navigatorKey,
  });

  final Destination destination;
  final Key navigatorKey;

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    debugPrint("widget.destination.index: ${widget.destination.index}");
    switch (widget.destination.index) {
      case 0:
        return HomePage(destination: widget.destination);
      case 1:
        return JournalPage(destination: widget.destination);
      case 2:
        return PartnersPage(destination: widget.destination);
      case 3:
        return SettingsPage(destination: widget.destination);
      default:
        return const LoginPage();
    }
  }
}
