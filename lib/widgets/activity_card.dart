import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/widgets/activity_item.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      //color: Theme.of(context).colorScheme.surfaceVariant,
      child: ActivityItem(activity: widget.activity),
    );
  }
}
