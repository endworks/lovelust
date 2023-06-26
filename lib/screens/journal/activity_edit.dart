import 'package:flutter/material.dart';
import 'package:lovelust/forms/activity_form.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/model_entry_item.dart';

class ActivityEditPage extends StatefulWidget {
  const ActivityEditPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  void save() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit activity'),
        actions: [
          FilledButton(onPressed: save, child: const Text('Save')),
          PopupMenuButton(
            onSelected: (MenuEntryItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuEntryItem>>[
              const PopupMenuItem(
                value: MenuEntryItem.info,
                child: Text('Info'),
              ),
            ],
          ),
        ],
      ),
      body: ActivityForm(activity: widget.activity),
    );
  }
}
