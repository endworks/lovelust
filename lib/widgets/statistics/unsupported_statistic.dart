import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';

class UnsupportedStatistic extends StatelessWidget {
  const UnsupportedStatistic({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          AppLocalizations.of(context)!.unsupportedStatistic,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.unsupportedStatisticDescription,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.question_mark,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
