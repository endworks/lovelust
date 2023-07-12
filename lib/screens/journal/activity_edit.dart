import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(widget.activity.id.isEmpty
            ? AppLocalizations.of(context)!.logActivity
            : AppLocalizations.of(context)!.editActivity),
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
      body: ActivityForm(activity: widget.activity),
    );
  }
}
