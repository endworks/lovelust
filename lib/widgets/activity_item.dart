import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  final CommonService _commonService = getIt<CommonService>();
  Partner? partner;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (widget.activity.partner != null) {
        _commonService
            .getPartnerById(widget.activity.partner!)
            .then((value) async {
          setState(() {
            partner = value;
          });
        });
      }
    }
  }

  void _openActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  CircleAvatar avatar() {
    if (widget.activity.type != 'MASTURBATION') {
      if (partner != null) {
        return CircleAvatar(
          backgroundColor: partner!.gender == 'M' ? Colors.blue : Colors.red,
          child: Icon(
            partner!.sex == 'M' ? Icons.male : Icons.female,
            color: Colors.white,
          ),
        );
      } else {
        return CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Icon(
            Icons.person_off,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } else {
      return CircleAvatar(
        backgroundColor: Colors.pink[300],
        child: const Icon(
          Icons.front_hand,
          color: Colors.white,
        ),
      );
    }
  }

  Text title() {
    if (widget.activity.type == 'MASTURBATION') {
      return Text('Solo',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[300]));
    }
    return Text(partner != null ? partner!.name : 'Unknown partner',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary));
  }

  Icon? safetyIcon() {
    if (widget.activity.type != 'MASTURBATION') {
      if (widget.activity.safety == 'safe') {
        return const Icon(Icons.check_circle, color: Colors.green);
      } else if (widget.activity.safety == 'unsafe') {
        return const Icon(Icons.error, color: Colors.red);
      } else {
        return const Icon(Icons.help, color: Colors.orange);
      }
    }
    return null;
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.activity.date);
  }

  String place() {
    if (widget.activity.place != null) {
      return widget.activity.place!.capitalize();
    }

    return 'Unknown place';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: avatar(),
        title: title(),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text(date())),
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text("${widget.activity.duration} min.")),
          ]),
        ]),
        trailing: safetyIcon(),
        onTap: _openActivity);
  }
}
