import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

import 'activity_edit.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  final CommonService _commonService = getIt<CommonService>();
  Partner? partner;
  bool solo = false;

  void editActivity() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return ActivityEditPage(activity: widget.activity);
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      partner = _commonService.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
    setState(() {
      solo = widget.activity.type == 'MASTURBATION';
    });
  }

  Widget title() {
    String title;
    if (solo) {
      title = 'Solo';
    } else {
      switch (widget.activity.safety) {
        case 'safe':
          title = 'Safe sex';

          break;
        case 'unsafe':
          title = 'Unsafe sex';

          break;
        default:
          title = 'Partly unsafe sex';
      }
    }
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        actions: [
          IconButton(onPressed: editActivity, icon: const Icon(Icons.edit)),
          PopupMenuButton(
            onSelected: (MenuEntryItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuEntryItem>>[
              const PopupMenuItem(
                value: MenuEntryItem.delete,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
