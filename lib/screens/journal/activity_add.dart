import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/forms/activity_form.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';

class ActivityAddPage extends StatefulWidget {
  const ActivityAddPage({super.key});

  @override
  State<ActivityAddPage> createState() => _ActivityAddPageState();
}

class _ActivityAddPageState extends State<ActivityAddPage> {
  Activity activity = Activity(
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
    type: null,
    practices: null,
    safety: null,
    encounters: 0,
  );

  void save() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.logActivity),
        actions: [
          FilledButton(
              onPressed: save, child: Text(AppLocalizations.of(context)!.save)),
          PopupMenuButton(
            onSelected: (MenuEntryItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuEntryItem>>[
              PopupMenuItem(
                value: MenuEntryItem.help,
                child: Text(AppLocalizations.of(context)!.help),
              ),
            ],
          ),
        ],
      ),
      body: ActivityForm(activity: activity),
    );
  }
}
