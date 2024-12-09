import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class NotesBlock extends StatefulWidget {
  const NotesBlock({super.key, required this.notes});

  final String notes;

  @override
  State<NotesBlock> createState() => _NotesBlockState();
}

class _NotesBlockState extends State<NotesBlock> {
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
          AppLocalizations.of(context)!.notes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: _shared.privacyRedactedText(
          widget.notes,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.text_snippet,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
