import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';
import 'package:relative_time/relative_time.dart';

class ActivityItemInfo extends StatefulWidget {
  const ActivityItemInfo({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItemInfo> createState() => _ActivityItemInfoState();
}

class _ActivityItemInfoState extends State<ActivityItemInfo> {
  final SharedService _shared = getIt<SharedService>();
  Partner? partner;
  bool solo = false;

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
      solo = widget.activity.type == 'MASTURBATION';
    });
  }

  void openActivity() {
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  Widget get safetyCircle {
    if (widget.activity.type != 'MASTURBATION') {
      late IconData icon;
      Color color = Theme.of(context).colorScheme.secondary;
      ActivitySafety safety = _shared.calculateSafety(widget.activity);
      if (safety == ActivitySafety.safe) {
        icon = Icons.check;
      } else if (safety == ActivitySafety.unsafe) {
        icon = Icons.priority_high;
        color = Colors.red
          ..harmonizeWith(Theme.of(context).colorScheme.primary);
      } else {
        icon = Icons.question_mark;
        color = Colors.orange
          ..harmonizeWith(Theme.of(context).colorScheme.primary);
      }
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(
          icon,
          color: color,
        ),
      );
    }
    return const SizedBox();
  }

  String get date {
    return RelativeTime(context).format(widget.activity.date);
    // return DateFormat('dd MMMM yyyy HH:mm').format(widget.activity.date);
  }

  String get place {
    if (widget.activity.place != null) {
      return widget.activity.place!.capitalize();
    }

    return AppLocalizations.of(context)!.unknownPlace;
  }

  Widget get time {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        DateFormat('hh:mm').format(widget.activity.date),
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget get placeIcon {
    IconData icon = Icons.bed;

    switch (widget.activity.place) {
      case 'BEDROOM':
        icon = Icons.bed;
        break;
      case 'PUBLIC':
        icon = Icons.park;
        break;
      case 'SOFA':
        icon = Icons.weekend;
        break;
      case 'TABLE':
        icon = Icons.table_restaurant;
        break;
      default:
        icon = Icons.bed;
    }

    return Row(children: [
      Icon(
        icon,
        color: Theme.of(context).colorScheme.outline,
        size: 13,
      ),
      widget.activity.place != null
          ? Text(
              _shared.getPlaceById(widget.activity.place!)!.name,
              style: secondaryTextStyle(),
            )
          : Text(
              'Unknown place',
              style: secondaryTextStyle(),
            )
    ]);
  }

  Widget get rating {
    List<Widget> container = [];
    Color color = Theme.of(context).colorScheme.secondary;
    if (widget.activity.rating > 0) {
      color = Colors.red;
    }
    if (widget.activity.rating > 2) {
      color = Colors.deepOrangeAccent;
    }
    if (widget.activity.rating > 3) {
      color = Colors.amber;
    }
    color = color.harmonizeWith(Theme.of(context).colorScheme.primary);

    Icon star = Icon(
      Icons.star,
      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
      color: color,
    );
    Icon starEmpty = Icon(
      Icons.star_border,
      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    );
    if (widget.activity.rating > 0) {
      container.add(star);
    }
    if (widget.activity.rating > 1) {
      container.add(star);
    }
    if (widget.activity.rating > 2) {
      container.add(star);
    }
    if (widget.activity.rating > 3) {
      container.add(star);
    }
    if (widget.activity.rating > 4) {
      container.add(star);
    }

    int needsToBeFilled = 4 - container.length;
    for (int i = 0; i <= needsToBeFilled; i++) {
      container.add(starEmpty);
    }

    return Row(
      children: container,
    );
  }

  Widget protection() {
    if (solo) {
      return const Text('');
    }
    String text = 'No protection';
    if (widget.activity.birthControl == null ||
        widget.activity.birthControl == 'NO_BIRTH_CONTROL') {
      if (widget.activity.partnerBirthControl != null &&
          widget.activity.partnerBirthControl != 'NO_BIRTH_CONTROL') {
        text = _shared
            .getBirthControlById(widget.activity.partnerBirthControl!)!
            .name;
      }
    } else if (widget.activity.partnerBirthControl == null ||
        widget.activity.partnerBirthControl == 'NO_BIRTH_CONTROL') {
      if (widget.activity.birthControl != null &&
          widget.activity.birthControl != 'NO_BIRTH_CONTROL') {
        text = _shared.getBirthControlById(widget.activity.birthControl!)!.name;
      }
    } else {
      if (widget.activity.birthControl == widget.activity.partnerBirthControl) {
        text = _shared.getBirthControlById(widget.activity.birthControl!)!.name;
      } else {
        text =
            '${_shared.getBirthControlById(widget.activity.birthControl!)!.name} + ${_shared.getBirthControlById(widget.activity.partnerBirthControl!)!.name}';
      }
    }

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(text, style: secondaryTextStyle()),
    );
  }

  Widget duration() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        '${widget.activity.duration} min.',
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget get partnerName {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    if (widget.activity.type != 'MASTURBATION') {
      if (partner != null) {
        return _shared.sensitiveText(partner!.name, style: style);
      } else {
        return Text(
          AppLocalizations.of(context)!.unknownPartner,
          style: style,
        );
      }
    } else {
      return Text(
        AppLocalizations.of(context)!.solo,
        style: style,
      );
    }
  }

  String get activityTitle {
    String title;

    if (solo) {
      title = AppLocalizations.of(context)!.masturbation;
    } else {
      ActivitySafety safety = _shared.calculateSafety(widget.activity);
      switch (safety) {
        case ActivitySafety.safe:
          title = AppLocalizations.of(context)!.safeSex;

          break;
        case ActivitySafety.unsafe:
          title = AppLocalizations.of(context)!.unsafeSex;

          break;
        default:
          title = AppLocalizations.of(context)!.partlyUnsafeSex;
      }
    }
    return title;
  }

  TextStyle secondaryTextStyle() {
    return Theme.of(context).textTheme.bodySmall!;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: openActivity,
      title: Row(
        children: [
          ActivityAvatar(
            partnerId: widget.activity.partner,
            masturbation: solo,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                partnerName,
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          const Spacer(),
          safetyCircle,
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activityTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          rating,
        ],
      ),
    );
  }
}
