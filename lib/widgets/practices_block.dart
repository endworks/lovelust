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

  String? getPracticeName(Practice practice) {
    if (practice == Practice.anal) {
      return AppLocalizations.of(context)!.anal;
    } else if (practice == Practice.bdsm) {
      return AppLocalizations.of(context)!.bdsm;
    } else if (practice == Practice.bondage) {
      return AppLocalizations.of(context)!.bondage;
    } else if (practice == Practice.choking) {
      return AppLocalizations.of(context)!.choking;
    } else if (practice == Practice.cuddling) {
      return AppLocalizations.of(context)!.cuddling;
    } else if (practice == Practice.domination) {
      return AppLocalizations.of(context)!.domination;
    } else if (practice == Practice.finger) {
      return AppLocalizations.of(context)!.finger;
    } else if (practice == Practice.handjob) {
      return AppLocalizations.of(context)!.handjob;
    } else if (practice == Practice.masturbation) {
      return AppLocalizations.of(context)!.masturbation;
    } else if (practice == Practice.oral) {
      return AppLocalizations.of(context)!.oral;
    } else if (practice == Practice.toy) {
      return AppLocalizations.of(context)!.toy;
    } else if (practice == Practice.vaginal) {
      return AppLocalizations.of(context)!.vaginal;
    }
    return null;
  }

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
                label: _shared.sensitiveText(getPracticeName(e)!),
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
