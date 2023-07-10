import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/activity_item.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final CommonService _common = getIt<CommonService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: ActivityItem(activity: widget.activity),
    );
  }
}
