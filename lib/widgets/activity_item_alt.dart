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

class ActivityItemAlt extends StatefulWidget {
  const ActivityItemAlt({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItemAlt> createState() => _ActivityItemAltState();
}

class _ActivityItemAltState extends State<ActivityItemAlt> {
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
      solo = widget.activity.type == ActivityType.masturbation;
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

  Icon? safetyIcon() {
    if (widget.activity.type != ActivityType.masturbation) {
      ActivitySafety safety = _shared.calculateSafety(widget.activity);
      if (safety == ActivitySafety.safe) {
        return Icon(Icons.check_circle,
            color: Colors.green
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      } else if (safety == ActivitySafety.unsafe) {
        return Icon(Icons.error,
            color: Colors.red
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      } else {
        return Icon(Icons.help,
            color: Colors.orange
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      }
    }
    return null;
  }

  Widget date() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        DateFormat('dd MMMM yyyy').format(widget.activity.date),
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget time() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        DateFormat('hh:mm').format(widget.activity.date),
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget place() {
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
              AppLocalizations.of(context)!.unknownPlace,
              style: secondaryTextStyle(),
            )
    ]);
  }

  Widget protection() {
    if (solo) {
      return const Text('');
    }
    String text = AppLocalizations.of(context)!.noBirthControl;
    if (widget.activity.birthControl == null) {
      if (widget.activity.partnerBirthControl != null) {
        text = widget.activity.partnerBirthControl.toString();
      }
    } else if (widget.activity.partnerBirthControl == null) {
      if (widget.activity.birthControl != null) {
        text = widget.activity.birthControl.toString();
      }
    } else {
      if (widget.activity.birthControl == widget.activity.partnerBirthControl) {
        text = widget.activity.birthControl.toString();
      } else {
        text =
            '${widget.activity.birthControl.toString()} + ${widget.activity.partnerBirthControl.toString()}';
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
        '${widget.activity.duration} ${AppLocalizations.of(context)!.min}',
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget partnerName() {
    return Text(
      partner != null ? partner!.name : '',
      style: secondaryTextStyle(),
    );
  }

  Widget activity() {
    String title;
    Color color = Theme.of(context).colorScheme.onSurface;
    if (solo) {
      title = 'Solo';
    } else {
      ActivitySafety safety = _shared.calculateSafety(widget.activity);
      switch (safety) {
        case ActivitySafety.safe:
          title = AppLocalizations.of(context)!.safeSex;

          color =
              Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);

          break;
        case ActivitySafety.unsafe:
          title = AppLocalizations.of(context)!.unsafeSex;

          color =
              Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);

          break;
        default:
          title = AppLocalizations.of(context)!.partlyUnsafeSex;

          color = Colors.orange
              .harmonizeWith(Theme.of(context).colorScheme.primary);
      }
    }
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  TextStyle secondaryTextStyle() {
    return const TextStyle(
      // color: Theme.of(context).colorScheme.outline,
      fontSize: 13,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: openActivity,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [place(), time(), protection()],
              ),
              activity(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [partnerName(), duration()],
              )
            ],
          ),
          ActivityAvatar(
            partnerId: widget.activity.partner,
            masturbation: solo,
          )
        ],
      ),
    );
  }
}
