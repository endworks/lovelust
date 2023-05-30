import 'package:flutter/material.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key});

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircleAvatar(child: Text('A')),
      title: Text('Headline'),
      subtitle: Text('Supporting text'),
      trailing: Icon(Icons.favorite_rounded),
    );
  }
}
