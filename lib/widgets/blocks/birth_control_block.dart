import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class BirthControlBlock extends StatefulWidget {
  const BirthControlBlock({
    super.key,
    required this.birthControl,
    required this.partnerBirthControl,
  });

  final Contraceptive? birthControl;
  final Contraceptive? partnerBirthControl;

  @override
  State<BirthControlBlock> createState() => _BirthControlBlockState();
}

class _BirthControlBlockState extends State<BirthControlBlock> {
  final SharedService _shared = getIt<SharedService>();

  List<Widget> get birthControl {
    List<Widget> list = [];
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    if (widget.birthControl == widget.partnerBirthControl) {
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              SharedService.getContraceptiveTranslation(
                widget.birthControl,
              ),
              style: style,
            ),
            Text(' ${AppLocalizations.of(context)!.byBoth}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    } else {
      if (widget.birthControl != null) {
        list.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                SharedService.getContraceptiveTranslation(
                  widget.birthControl,
                ),
                style: style,
              ),
              Text(' ${AppLocalizations.of(context)!.byMe}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      } else if (widget.partnerBirthControl != null) {
        list.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                SharedService.getContraceptiveTranslation(
                  widget.partnerBirthControl,
                ),
                style: style,
              ),
              Text(' ${AppLocalizations.of(context)!.byPartner}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      }
    }
    return list;
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
          AppLocalizations.of(context)!.birthControl,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: birthControl,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.medication,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
