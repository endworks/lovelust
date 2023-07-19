import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
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
  final SharedService _common = getIt<SharedService>();

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
    IconData icon = Icons.help;
    Color color = Colors.orange;
    String label = AppLocalizations.of(context)!.partlyUnsafe;
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    if (widget.activity.safety == 'safe') {
      icon = Icons.check_circle;
      color = Colors.green;
      label = AppLocalizations.of(context)!.safe;
    } else if (widget.activity.safety == 'unsafe') {
      icon = Icons.error;
      color = Colors.red;
      label = AppLocalizations.of(context)!.unsafe;
    }

    color = color.harmonizeWith(Theme.of(context).colorScheme.primary);

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: style.fontSize,
        ),
        Text(label, style: style),
      ],
    );
  }

  Widget get duration {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    IdName place = _common.getPlaceById(widget.activity.place!)!;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: widget.activity.duration.toString(), style: style),
          TextSpan(text: '${AppLocalizations.of(context)!.min} '),
          TextSpan(text: place.name, style: style),
        ],
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
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      clipBehavior: Clip.antiAlias,
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
