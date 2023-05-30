import 'package:flutter/material.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: FlutterLogo(),
        title: Text('One-line with leading widget'),
      ),
    );
  }
}
