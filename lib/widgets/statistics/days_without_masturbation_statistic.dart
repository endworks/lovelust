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
  Color? foreground;
  Color? background;

  @override
  void initState() {
    super.initState();
    if (widget.days >= 30) {
      foreground = Colors.white;
      background = Colors.red;
    } else if (widget.days >= 14) {
      foreground = Colors.white;
      background = Colors.amber;
    } else if (widget.days >= 7) {
      foreground = Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.daysWithoutMasturbation,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Text(
          widget.days.toString(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: foreground ?? Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
