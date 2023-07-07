import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';

import 'activity_edit.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();
  int alpha = Colors.black26.alpha;
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
      partner = _common.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
    setState(() {
      solo = widget.activity.type == 'MASTURBATION';
    });
  }

  String get title {
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
    return title;
  }

  Color get headerForegroundColor {
    return Theme.of(context).colorScheme.inverseSurface;
  }

  Color get headerBackgroundColor {
    if (solo) {
      return Colors.pink
          .harmonizeWith(Theme.of(context).colorScheme.primary)
          .withAlpha(alpha);
    }

    switch (widget.activity.safety) {
      case 'safe':
        return Colors.green
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(alpha);

      case 'unsafe':
        return Colors.red
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(alpha);

      default:
        return Colors.orange
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(alpha);
    }
  }

  Icon? get safetyIcon {
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

  void menuEntryItemSelected(MenuEntryItem item) {
    debugPrint(item.name);
    if (item.name == 'delete') {
      if (_common.isLoggedIn) {
        _api.deleteActivity(widget.activity).then(
              (value) => Navigator.pop(context),
            );
      } else {
        List<Activity> activity = [..._common.activity];
        activity.removeWhere((element) => element.id == widget.activity.id);
        setState(() {
          _common.activity = activity;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar.large(
              floating: false,
              pinned: true,
              title: Text(title),
              backgroundColor: headerBackgroundColor,
              actions: [
                IconButton(
                    onPressed: editActivity, icon: const Icon(Icons.edit)),
                PopupMenuButton(
                  onSelected: menuEntryItemSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuEntryItem>>[
                    const PopupMenuItem(
                      value: MenuEntryItem.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.activity.notes ?? '',
            )
          ],
        ),
      ),
    );
  }
}
