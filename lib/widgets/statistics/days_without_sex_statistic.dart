import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';

class DaysWithoutSexStatistic extends StatefulWidget {
  const DaysWithoutSexStatistic({super.key, required this.data});

  final DaysWithoutSexData data;

  @override
  State<DaysWithoutSexStatistic> createState() =>
      _DaysWithoutSexStatisticState();
}

class _DaysWithoutSexStatisticState extends State<DaysWithoutSexStatistic> {
  Color getForeground(int days) {
    if (days >= 30) {
      return Colors.white.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days >= 14) {
      return Colors.white.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (days >= 7) {
      return Colors.amber.harmonizeWith(Theme.of(context).colorScheme.primary);
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
              top: 4,
              bottom: 4,
              end: 4,
            ),
            child: ListTile(
              title: Text(
                AppLocalizations.of(context)!.daysWithoutSex,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: CircleAvatar(
                backgroundColor:
                    getBackground(widget.data.daysWithoutRelationship),
                child: Text(
                  widget.data.daysWithoutRelationship.toString(),
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
              title: Text(
                AppLocalizations.of(context)!.daysWithoutMasturbation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: CircleAvatar(
                backgroundColor:
                    getBackground(widget.data.daysWithoutMasturbation),
                child: Text(
                  widget.data.daysWithoutMasturbation.toString(),
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
