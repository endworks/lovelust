import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/activity_details.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key, required this.activity});

  final Activity activity;

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

  CircleAvatar avatar() {
    if (widget.activity.type != 'MASTURBATION') {
      return const CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.female,
          color: Colors.white,
        ),
      );
    } else {
      return const CircleAvatar(
        backgroundColor: Colors.pink,
        child: Icon(
          Icons.front_hand,
          color: Colors.white,
        ),
      );
    }
  }

  Text title() {
    if (widget.activity.type == 'MASTURBATION') {
      return const Text('Solo');
    }
    return Text(widget.activity.partner ?? 'Unknown');
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: avatar(),
        title: title(),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.calendar_today, size: 16),
            Text(widget.activity.date.toLocal().toString())
          ]),
          Row(children: [
            const Icon(Icons.location_on, size: 16),
            Text(widget.activity.place ?? 'test'),
            const Icon(Icons.timer, size: 16),
            Text(widget.activity.duration.toString())
          ]),
        ]),
        trailing: safetyIcon(),
        onTap: _openActivity);
  }
}
