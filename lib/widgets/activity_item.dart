import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';
import 'package:relative_time/relative_time.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  final SharedService _shared = getIt<SharedService>();
  Partner? partner;

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      partner = _shared.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
  }

  void _openActivity() {
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  Widget get title {
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
    return RelativeTime(context).format(widget.activity.date);
    // return DateFormat('dd MMMM yyyy HH:mm').format(widget.activity.date);
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
        subtitle: Text(date),
        trailing: safetyIcon,
        onTap: _openActivity);
  }
}
