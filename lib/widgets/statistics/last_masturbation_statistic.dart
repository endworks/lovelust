import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:relative_time/relative_time.dart';

class LastMasturbationStatistic extends StatefulWidget {
  const LastMasturbationStatistic({super.key, required this.activity});

  final Activity activity;

  @override
  State<LastMasturbationStatistic> createState() =>
      _LastMasturbationStatisticState();
}

class _LastMasturbationStatisticState extends State<LastMasturbationStatistic> {
  final SharedService _shared = getIt<SharedService>();

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
          AppLocalizations.of(context)!.lastMasturbation,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          RelativeTime(context, numeric: true).format(widget.activity.date),
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
