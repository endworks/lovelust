import 'package:flutter/material.dart';
import 'package:lovelust/screens/activity_details.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key});

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  void _openActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return const ActivityDetailsPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.female,
            color: Colors.white,
          ),
        ),
        title: const Text('Big titty goth gf'),
        subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('10 March 2023'), Text('Bedroom')]),
        trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
        onTap: _openActivity);
  }
}
