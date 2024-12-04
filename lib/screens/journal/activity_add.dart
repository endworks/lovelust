import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';

class ActivityAddPage extends StatefulWidget {
  const ActivityAddPage({super.key});

  @override
  State<ActivityAddPage> createState() => _ActivityAddPageState();
}

class _ActivityAddPageState extends State<ActivityAddPage> {
  late Activity activity;

  @override
  void initState() {
    super.initState();
    activity = Activity(
      id: '',
      partner: null,
      birthControl: null,
      partnerBirthControl: null,
      date: DateTime.now(),
      location: null,
      notes: null,
      duration: 0,
      orgasms: 0,
      partnerOrgasms: 0,
      place: null,
      initiator: null,
      rating: 0,
      type: ActivityType.sexualIntercourse,
      practices: null,
      mood: null,
      watchedPorn: false,
      ejaculation: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActivityEditPage(activity: activity);
  }
}
