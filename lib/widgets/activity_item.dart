import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  final CommonService _commonService = getIt<CommonService>();
  Partner? partner;

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      partner = _commonService.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
  }

  void _openActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  Text get title {
    if (widget.activity.type != 'MASTURBATION') {
      if (partner != null) {
        return Text(
          partner!.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        );
      } else {
        return Text(
          AppLocalizations.of(context)!.unknownPartner,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        );
      }
    } else {
      return Text(
        AppLocalizations.of(context)!.solo,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  Icon? get safetyIcon {
    if (widget.activity.type != 'MASTURBATION') {
      if (widget.activity.safety == 'safe') {
        return Icon(Icons.check_circle,
            color: Colors.green
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      } else if (widget.activity.safety == 'unsafe') {
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

  String get date {
    return DateFormat('dd MMMM yyyy').format(widget.activity.date);
  }

  String get place {
    if (widget.activity.place != null) {
      return widget.activity.place!.capitalize();
    }

    return AppLocalizations.of(context)!.unknownPlace;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ActivityAvatar(
          partnerId: widget.activity.partner,
          masturbation: widget.activity.type == 'MASTURBATION',
        ),
        title: title,
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text(date)),
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text("${widget.activity.duration} min.")),
          ]),
        ]),
        trailing: safetyIcon,
        onTap: _openActivity);
  }
}
