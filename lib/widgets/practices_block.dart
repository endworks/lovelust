import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PracticesBlock extends StatefulWidget {
  const PracticesBlock({super.key, required this.practices});

  final List<IdName> practices;

  @override
  State<PracticesBlock> createState() => _PracticesBlockState();
}

class _PracticesBlockState extends State<PracticesBlock> {
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
          AppLocalizations.of(context)!.practices,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            ...widget.practices.map(
              (e) => Chip(
                label: _shared.sensitiveText(e.name),
              ),
            )
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.task_alt,
            color: Colors.blue
                .harmonizeWith(Theme.of(context).colorScheme.primary),
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
