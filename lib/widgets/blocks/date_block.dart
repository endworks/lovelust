import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class DateBlock extends StatefulWidget {
  const DateBlock({super.key, required this.date, required this.label});

  final DateTime date;
  final String label;

  @override
  State<DateBlock> createState() => _DateBlockState();
}

class _DateBlockState extends State<DateBlock> {
  final SharedService _shared = getIt<SharedService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: _shared.privacyRedactedText(
          DateFormat.yMMMEd().format(widget.date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
