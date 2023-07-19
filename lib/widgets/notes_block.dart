import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesBlock extends StatefulWidget {
  const NotesBlock({super.key, required this.notes});

  final String notes;

  @override
  State<NotesBlock> createState() => _NotesBlockState();
}

class _NotesBlockState extends State<NotesBlock> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.notes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          widget.notes,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
