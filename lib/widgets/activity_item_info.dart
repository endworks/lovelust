import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
  Partner? _partner;
  bool _solo = false;

  @override
  void initState() {
    if (widget.activity.partner != null) {
      _partner = _shared.getPartnerById(widget.activity.partner!);
    }
    _solo = widget.activity.type == ActivityType.masturbation;
    super.initState();
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
    if (widget.activity.type != ActivityType.masturbation) {
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
    return RelativeTime(context, numeric: true).format(widget.activity.date);
  }

  String get place {
    if (widget.activity.place != null) {
      return widget.activity.place.toString();
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
      case Place.bedroom:
        icon = Icons.bed;
        break;
      case Place.public:
        icon = Icons.park;
        break;
      case Place.sofa:
        icon = Icons.weekend;
        break;
      case Place.table:
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
              widget.activity.place.toString(),
              style: secondaryTextStyle(),
            )
          : Text(
              'Unknown place',
              style: secondaryTextStyle(),
            )
    ]);
  }

  Widget duration() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        '${widget.activity.duration} ${AppLocalizations.of(context)!.min}',
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget get partnerName {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    if (widget.activity.type != ActivityType.masturbation) {
      if (_partner != null) {
        return _shared.sensitiveText(_partner!.name, style: style);
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

    if (_solo) {
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
          title = AppLocalizations.of(context)!.partiallyUnsafeSex;
      }
    }
    return title;
  }

  String? get mood {
    if (widget.activity.mood == null) {
      return null;
    }
    return SharedService.getMoodTranslation(widget.activity.mood);
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
            masturbation: _solo,
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
          mood != null
              ? Text(
                  mood!,
                  style: Theme.of(context).textTheme.labelLarge,
                )
              : const SizedBox(),
          /*widget.activity.rating > 0
              ? Rating(rating: widget.activity.rating)
              : SizedBox(), */
        ],
      ),
    );
  }
}
