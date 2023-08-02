import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';
import 'package:lovelust/widgets/birth_control_block.dart';
import 'package:lovelust/widgets/highlights_block.dart';
import 'package:lovelust/widgets/notes_block.dart';
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
  final NavigationService _navigator = getIt<NavigationService>();
  final ApiService _api = getIt<ApiService>();
  late Activity _activity;
  Partner? _partner;
  bool _solo = false;

  void editActivity() {
    _navigator.navigateTo(
      MaterialPageRoute<Widget>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return ActivityEditPage(activity: _activity);
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
    _shared.addListener(() {
      if (mounted) {
        setState(() {
          _activity = _shared.getActivityById(_activity.id!)!;
          if (_activity.partner != null) {
            _partner = _shared.getPartnerById(_activity.partner!);
          }
          _solo = _activity.type == ActivityType.masturbation;
        });
      }
    });
    _solo = _activity.type == ActivityType.masturbation;
    if (_activity.partner != null) {
      _partner = _shared.getPartnerById(_activity.partner!);
    }
  }

  String get title {
    if (!_solo) {
      if (_partner != null) {
        return _partner!.name;
      } else {
        return AppLocalizations.of(context)!.unknownPartner;
      }
    } else {
      return AppLocalizations.of(context)!.solo;
    }
  }

  Icon? get safetyIcon {
    if (_activity.type != ActivityType.masturbation) {
      ActivitySafety safety = _shared.calculateSafety(_activity);
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
        _api.deleteActivity(_activity).then(
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
        activity.removeWhere((element) => element.id == _activity.id);
        setState(() {
          _shared.activity = activity;
        });
        Navigator.pop(context);
      }
    }
  }

  Widget? get encounters {
    TextStyle style = Theme.of(context).textTheme.titleLarge!;
    int count = _shared.getActivityByPartner(_activity.partner).length;
    if (count == 0) {
      return null;
    }
    Color color = Theme.of(context).colorScheme.secondary;
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
          partnerId: _activity.partner,
          masturbation: _solo,
        ),
        trailing: encounters,
        title: Row(
          children: [
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Padding(padding: EdgeInsets.only(left: 4)),
            _shared.sensitiveText(
              SharedService.getPlaceTranslation(_activity.place),
            ),
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
                _shared.sensitiveText(
                  DateFormat('dd MMMM yyyy').format(_activity.date),
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
                _shared.sensitiveText(
                  DateFormat('HH:mm').format(_activity.date),
                ),
                const Padding(padding: EdgeInsets.only(left: 16)),
                Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const Padding(padding: EdgeInsets.only(left: 4)),
                _shared.sensitiveText(_activity.duration.toString()),
                Text(' ${AppLocalizations.of(context)!.min}'),
              ],
            ),
            widget.activity.rating > 0
                ? Row(
                    children: [
                      Rating(rating: _activity.rating),
                    ],
                  )
                : const SizedBox()
          ],
        ),
        titleAlignment: ListTileTitleAlignment.top,
      )
    ];
    if (!_solo) {
      list.addAll([
        SafetyBlock(
          safety: _shared.calculateSafety(_activity),
        ),
        BirthControlBlock(
          birthControl: _activity.birthControl,
          partnerBirthControl: _activity.partnerBirthControl,
        ),
      ]);
    }

    if (_activity.orgasms > 0 ||
        _activity.partnerOrgasms > 0 ||
        _activity.initiator != null) {
      list.add(
        HighlightsBlock(
          orgasms: _activity.orgasms,
          partnerOrgasms: _activity.partnerOrgasms,
          initiator: _activity.initiator,
          mood: _activity.mood,
        ),
      );
    }

    if (_activity.practices != null && _activity.practices!.isNotEmpty) {
      list.add(
        PracticesBlock(
          practices: _activity.practices!,
        ),
      );
    }

    if (_activity.notes != null && _activity.notes!.isNotEmpty) {
      list.add(
        NotesBlock(
          notes: _activity.notes!,
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
