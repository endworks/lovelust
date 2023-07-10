import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/birth_control_block.dart';
import 'package:lovelust/widgets/notes_block.dart';
import 'package:lovelust/widgets/performance_block.dart';
import 'package:lovelust/widgets/practices_block.dart';
import 'package:lovelust/widgets/safety_block.dart';

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

  /*String get title {
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
  }*/

  String get title {
    if (widget.activity.type != 'MASTURBATION') {
      if (partner != null) {
        return partner!.name;
      } else {
        return 'Unknown partner';
      }
    } else {
      return 'Solo';
    }
  }

  Color get headerForegroundColor {
    return Theme.of(context).colorScheme.inverseSurface;
  }

  Color get headerBackgroundColor {
    return Theme.of(context).colorScheme.surface;
    /*if (!_common.monochrome) {
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
    } else {
      return Theme.of(context).colorScheme.surfaceVariant;
    }*/
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

  get cards {
    List<Widget> list = [];
    if (!solo) {
      list = [
        SafetyBlock(
          safety: widget.activity.safety!,
        ),
        BirthControlBlock(
          birthControl: _common.getBirthControlById(
            widget.activity.birthControl!,
          ),
          partnerBirthControl: _common.getBirthControlById(
            widget.activity.partnerBirthControl!,
          ),
        ),
        PerformanceBlock(
          orgasms: widget.activity.orgasms,
          partnerOrgasms: widget.activity.partnerOrgasms,
          initiator: _common.getInitiatorById(
            widget.activity.initiator!,
          )!,
        )
      ];
    }

    if (widget.activity.practices != null &&
        widget.activity.practices!.isNotEmpty) {
      list.add(
        PracticesBlock(
          practices: widget.activity.practices!,
        ),
      );
    }

    if (widget.activity.notes != null) {
      list.add(
        NotesBlock(
          notes: widget.activity.notes!,
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cards,
        ),
      ),
    );
  }
}
