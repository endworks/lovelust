import 'package:flutter/material.dart';
import 'package:lovelust/forms/activity_form.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/model_entry_item.dart';

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
        title: const Text('Create activity'),
        actions: [
          FilledButton(onPressed: save, child: const Text('Save')),
          PopupMenuButton(
            onSelected: (MenuEntryItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuEntryItem>>[
              const PopupMenuItem(
                value: MenuEntryItem.help,
                child: Text('Help'),
              ),
            ],
          ),
        ],
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: ActivityForm(activity: activity),
    );
  }
}
