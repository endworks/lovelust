import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class DaysWithoutSexStatistic extends StatefulWidget {
  const DaysWithoutSexStatistic({super.key, required this.data});

  final DaysWithoutSexData data;

  @override
  State<DaysWithoutSexStatistic> createState() =>
      _DaysWithoutSexStatisticState();
}

class _DaysWithoutSexStatisticState extends State<DaysWithoutSexStatistic> {
  final SharedService _shared = getIt<SharedService>();

  Color getForeground(int days) {
    if (days >= 30) {
      return Colors.white.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days >= 14) {
      return Colors.white.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days >= 7) {
      return Colors.amber.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days == 0) {
      return Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color getBackground(int days) {
    if (days >= 30) {
      return Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days >= 14) {
      return Colors.amber.harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsetsDirectional.only(
              start: 16,
              top: 8,
              bottom: 8,
              end: 8,
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.days,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _shared.inappropriateText(
                    AppLocalizations.of(context)!.withoutSex,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor:
                    getBackground(widget.data.daysWithoutRelationship),
                child: Text(
                  widget.data.daysWithoutRelationship >= 0
                      ? widget.data.daysWithoutRelationship.toString()
                      : '?',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            getForeground(widget.data.daysWithoutRelationship),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsetsDirectional.only(
              start: 4,
              top: 4,
              bottom: 4,
              end: 16,
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.days,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _shared.inappropriateText(
                    AppLocalizations.of(context)!.withoutMasturbation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor:
                    getBackground(widget.data.daysWithoutMasturbation),
                child: Text(
                  widget.data.daysWithoutMasturbation >= 0
                      ? widget.data.daysWithoutMasturbation.toString()
                      : '?',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            getForeground(widget.data.daysWithoutMasturbation),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
