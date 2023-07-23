import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class ActivityBlock extends StatefulWidget {
  const ActivityBlock({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityBlock> createState() => _ActivityBlockState();
}

class _ActivityBlockState extends State<ActivityBlock> {
  final SharedService _shared = getIt<SharedService>();

  void openActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  Widget get safety {
    IconData icon = Icons.check_circle;
    Color color = Colors.green;
    String label = AppLocalizations.of(context)!.safe;
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    ActivitySafety safety = _shared.calculateSafety(widget.activity);
    if (safety == ActivitySafety.partlySafe) {
      icon = Icons.help;
      color = Colors.orange;
      style = style.copyWith(color: color);
      label = AppLocalizations.of(context)!.partlyUnsafe;
    } else if (safety == ActivitySafety.unsafe) {
      icon = Icons.error;
      color = Colors.red;
      style = style.copyWith(color: color);
      label = AppLocalizations.of(context)!.unsafe;
    }

    color = color.harmonizeWith(Theme.of(context).colorScheme.primary);

    return Row(
      children: [
        Text(label, style: style),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            icon,
            color: color,
            size: style.fontSize,
          ),
        )
      ],
    );
  }

  Widget get duration {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _shared.sensitiveText(widget.activity.duration.toString(),
            style: style),
        Text('${AppLocalizations.of(context)!.min} '),
        _shared.sensitiveText(widget.activity.place.toString(), style: style),
      ],
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
        title: Row(children: [
          Text(
            AppLocalizations.of(context)!.sexualActivity,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [safety, duration],
        ),
      ),
    );
  }
}
