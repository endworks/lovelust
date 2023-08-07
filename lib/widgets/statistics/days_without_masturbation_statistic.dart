import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DaysWithoutMasturbationStatistic extends StatefulWidget {
  const DaysWithoutMasturbationStatistic({super.key, required this.days});

  final int days;

  @override
  State<DaysWithoutMasturbationStatistic> createState() =>
      _DaysWithoutMasturbationStatisticState();
}

class _DaysWithoutMasturbationStatisticState
    extends State<DaysWithoutMasturbationStatistic> {
  Color get foreground {
    if (widget.days >= 30) {
      return Colors.white..harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (widget.days >= 14) {
      return Colors.white..harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (widget.days >= 7) {
      return Colors.amber..harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color get background {
    if (widget.days >= 30) {
      return Colors.red..harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (widget.days >= 14) {
      return Colors.amber..harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.daysWithoutMasturbation,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: CircleAvatar(
        backgroundColor: background,
        child: Text(
          widget.days.toString(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
