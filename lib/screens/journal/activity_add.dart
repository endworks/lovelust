import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

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
    String? partner;
    Contraceptive? birthControl;
    Contraceptive? partnerBirthControl;

    if (_shared.stats.lastSexualActivity != null) {
      partner = _shared.stats.lastSexualActivity!.partner;
      birthControl = _shared.stats.lastSexualActivity!.birthControl;
      partnerBirthControl =
          _shared.stats.lastSexualActivity!.partnerBirthControl;
    }
    activity = Activity(
      id: '',
      partner: partner,
      birthControl: birthControl,
      partnerBirthControl: partnerBirthControl,
      date: _shared.calendarDate,
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
