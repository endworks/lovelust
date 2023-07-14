import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';
import 'package:lovelust/service_locator.dart';

import '../../services/shared_service.dart';

class ActivityAddPage extends StatefulWidget {
  const ActivityAddPage({super.key});

  @override
  State<ActivityAddPage> createState() => _ActivityAddPageState();
}

class _ActivityAddPageState extends State<ActivityAddPage> {
  final SharedService _shared = getIt<SharedService>();

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
      type: _shared.activityTypes[1].id,
      practices: null,
      safety: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActivityEditPage(activity: activity);
  }
}
