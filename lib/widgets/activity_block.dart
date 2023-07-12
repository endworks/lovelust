import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class ActivityBlock extends StatefulWidget {
  const ActivityBlock({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityBlock> createState() => _ActivityBlockState();
}

class _ActivityBlockState extends State<ActivityBlock> {
  final CommonService _common = getIt<CommonService>();

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

    TextStyle style = TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
    );

    return Row(
      children: [
        Icon(icon, color: color),
        Text(label, style: style),
      ],
    );
  }

  Widget get duration {
    TextStyle style = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
    IdName place = _common.getPlaceById(widget.activity.place!)!;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: widget.activity.duration.toString(), style: style),
          const TextSpan(text: 'min. '),
          TextSpan(text: place.name, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color pink =
        Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: openActivity,
        title: Row(children: [
          Icon(
            Icons.favorite,
            color: pink,
          ),
          Text(
            AppLocalizations.of(context)!.sexualActivity,
            style: TextStyle(
              color: pink,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
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
