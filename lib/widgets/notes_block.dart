import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        vertical: 4,
      ),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.notes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: _shared.sensitiveText(
          widget.notes,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.text_snippet,
            color: Colors.amber
                .harmonizeWith(Theme.of(context).colorScheme.primary),
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
