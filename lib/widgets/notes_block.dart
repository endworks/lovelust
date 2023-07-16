import 'package:dynamic_color/dynamic_color.dart';
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
    Color color =
        Colors.orange.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      elevation: 0,
      // color: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        title: Row(children: [
          Icon(Icons.note_alt,
              color: color,
              size: Theme.of(context).textTheme.headlineSmall!.fontSize),
          Text(
            AppLocalizations.of(context)!.notes,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ]),
        subtitle: Text(
          widget.notes,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
