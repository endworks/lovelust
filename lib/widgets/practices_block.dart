import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';

class PracticesBlock extends StatefulWidget {
  const PracticesBlock({super.key, required this.practices});

  final List<IdName> practices;

  @override
  State<PracticesBlock> createState() => _PracticesBlockState();
}

class _PracticesBlockState extends State<PracticesBlock> {
  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.blue.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      elevation: 0,
      //color: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.task_alt,
            color: color,
            size: Theme.of(context).textTheme.headlineSmall!.fontSize,
          ),
          Text(
            AppLocalizations.of(context)!.practices,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ]),
        subtitle: Wrap(
          children: [
            ...widget.practices.map(
              (e) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: Chip(
                  label: Text(e.name),
                  avatar: const Icon(Icons.check),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
