import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:relative_time/relative_time.dart';

class LastRelationshipStatistic extends StatefulWidget {
  const LastRelationshipStatistic({super.key, required this.activity});

  final Activity activity;

  @override
  State<LastRelationshipStatistic> createState() =>
      _LastRelationshipStatisticState();
}

class _LastRelationshipStatisticState extends State<LastRelationshipStatistic> {
  final SharedService _shared = getIt<SharedService>();
  Partner? _partner;

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      _partner = _shared.getPartnerById(widget.activity.partner!);
    }
  }

  void openActivity() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'ActivityDetails'),
        builder: (BuildContext context) => ActivityDetailsPage(
          activity: widget.activity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        onTap: openActivity,
        title: _shared.inappropriateText(
          AppLocalizations.of(context)!.lastRelationship,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _shared.privacyRedactedText(
              _partner != null
                  ? _partner!.name
                  : AppLocalizations.of(context)!.unknownPartner,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Text(' '),
            Text(
              RelativeTime(context, numeric: true).format(widget.activity.date),
            ),
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
