import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';
import 'package:lovelust/widgets/birth_control_block.dart';
import 'package:lovelust/widgets/notes_block.dart';
import 'package:lovelust/widgets/performance_block.dart';
import 'package:lovelust/widgets/practices_block.dart';
import 'package:lovelust/widgets/rating.dart';
import 'package:lovelust/widgets/safety_block.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  final SharedService _shared = getIt<SharedService>();
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
      partner = _shared.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
    setState(() {
      solo = widget.activity.type == ActivityType.masturbation;
    });
  }

  String get title {
    if (!solo) {
      if (partner != null) {
        return partner!.name;
      } else {
        return AppLocalizations.of(context)!.unknownPartner;
      }
    } else {
      return AppLocalizations.of(context)!.solo;
    }
  }

  Color get headerForegroundColor {
    return Theme.of(context).colorScheme.inverseSurface;
  }

  Icon? get safetyIcon {
    if (widget.activity.type != ActivityType.masturbation) {
      ActivitySafety safety = _shared.calculateSafety(widget.activity);
      if (safety == ActivitySafety.safe) {
        return const Icon(Icons.check_circle, color: Colors.green);
      } else if (safety == ActivitySafety.unsafe) {
        return const Icon(Icons.error, color: Colors.red);
      } else {
        return const Icon(Icons.help, color: Colors.orange);
      }
    }
    return null;
  }

  void menuEntryItemSelected(MenuEntryItem item) {
    if (item.name == 'delete') {
      if (_shared.isLoggedIn) {
        _api.deleteActivity(widget.activity).then(
          (value) {
            _api.getActivity().then((value) {
              setState(() {
                _shared.activity = value;
              });
              Navigator.pop(context);
            });
          },
        );
      } else {
        List<Activity> activity = [..._shared.activity];
        activity.removeWhere((element) => element.id == widget.activity.id);
        setState(() {
          _shared.activity = activity;
        });
        Navigator.pop(context);
      }
    }
  }

  Widget? get encounters {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    int count = _shared.getActivityByPartner(widget.activity.partner).length;
    if (count == 0) {
      return null;
    }
    Color color = Theme.of(context).colorScheme.onSecondaryContainer;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite,
          color: color,
          size: style.fontSize,
        ),
        _shared.sensitiveText(
          count.toString(),
          style: style.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }

  get cards {
    List<Widget> list = [
      ListTile(
        leading: ActivityAvatar(
          partnerId: widget.activity.partner,
          masturbation: solo,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: encounters,
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Padding(padding: EdgeInsets.only(left: 4)),
            Text(
              SharedService.getPlaceTranslation(context, widget.activity.place),
            ),
            const Padding(padding: EdgeInsets.only(left: 16)),
            Icon(
              Icons.timer,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Padding(padding: EdgeInsets.only(left: 4)),
            Text(
                "${widget.activity.duration.toString()} ${AppLocalizations.of(context)!.min}")
          ],
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const Padding(padding: EdgeInsets.only(left: 4)),
                Text(
                  DateFormat('dd MMMM yyyy').format(widget.activity.date),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const Padding(padding: EdgeInsets.only(left: 4)),
                Text(
                  DateFormat('HH:mm').format(widget.activity.date),
                ),
              ],
            ),
            Row(
              children: [
                Rating(rating: widget.activity.rating),
              ],
            ),
          ],
        ),
        titleAlignment: ListTileTitleAlignment.top,
      )
    ];
    if (!solo) {
      list.addAll([
        SafetyBlock(
          safety: _shared.calculateSafety(widget.activity),
        ),
        BirthControlBlock(
          birthControl: widget.activity.birthControl,
          partnerBirthControl: widget.activity.partnerBirthControl,
        ),
      ]);
    }

    if (widget.activity.orgasms > 0 ||
        widget.activity.partnerOrgasms > 0 ||
        widget.activity.initiator != null) {
      list.add(
        PerformanceBlock(
          orgasms: widget.activity.orgasms,
          partnerOrgasms: widget.activity.partnerOrgasms,
          initiator: widget.activity.initiator,
        ),
      );
    }

    if (widget.activity.practices != null &&
        widget.activity.practices!.isNotEmpty) {
      list.add(
        PracticesBlock(
          practices: widget.activity.practices!,
        ),
      );
    }

    if (widget.activity.notes != null && widget.activity.notes!.isNotEmpty) {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            title: _shared.sensitiveText(title),
            // backgroundColor: headerBackgroundColor,
            actions: [
              IconButton(onPressed: editActivity, icon: const Icon(Icons.edit)),
              PopupMenuButton(
                onSelected: menuEntryItemSelected,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuEntryItem>>[
                  PopupMenuItem(
                    value: MenuEntryItem.delete,
                    child: Text(AppLocalizations.of(context)!.delete),
                  ),
                ],
              ),
            ],
          ),
          SliverList.list(
            children: cards,
          ),
        ],
      ),
    );
  }
}
