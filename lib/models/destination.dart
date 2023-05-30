import 'package:flutter/material.dart';
import 'package:lovelust/screens/activity.dart';
import 'package:lovelust/screens/learn.dart';
import 'package:lovelust/screens/partners.dart';
import 'package:lovelust/screens/stats.dart';

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
    switch (widget.destination.index) {
      case 0:
        return ActivityPage(destination: widget.destination);
      case 1:
        return PartnersPage(destination: widget.destination);
      case 2:
        return StatsPage(destination: widget.destination);
      case 3:
        return LearnPage(destination: widget.destination);
      default:
        return const Text('');
    }
  }
}
