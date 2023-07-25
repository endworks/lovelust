import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PracticesBlock extends StatefulWidget {
  const PracticesBlock({super.key, required this.practices});

  final List<Practice> practices;

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
              (e) => FilterChip(
                label: _shared.sensitiveText(
                    SharedService.getPracticeTranslation(context, e)),
                selected: true,
                onSelected: (value) {},
              ),
            )
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.task_alt,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
