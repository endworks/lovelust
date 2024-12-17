import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';

class SimpleStatistic extends StatefulWidget {
  const SimpleStatistic({
    super.key,
    required this.data,
  });

  final SimpleStatisticData data;

  @override
  State<SimpleStatistic> createState() => _SimpleStatisticState();
}

class _SimpleStatisticState extends State<SimpleStatistic> {
  Widget? get description {
    String description = widget.data.description;
    if (widget.data.count != null) {
      description +=
          " (${widget.data.count!} ${AppLocalizations.of(context)!.countNumber(widget.data.count!)})";
    }
    return Text(description);
  }

  Widget? get icon {
    if (widget.data.icon != null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(
          widget.data.icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          widget.data.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: description,
        trailing: icon,
      ),
    );
  }
}
