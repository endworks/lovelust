import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/widgets/activity_item_info.dart';

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
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: ActivityItemInfo(activity: widget.activity),
    );
  }
}
