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
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.notes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          !_shared.privacyMode
              ? widget.notes
              : widget.notes.replaceAll(RegExp(r"."), _shared.obscureCharacter),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
