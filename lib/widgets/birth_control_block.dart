import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class BirthControlBlock extends StatefulWidget {
  const BirthControlBlock({
    super.key,
    required this.birthControl,
    required this.partnerBirthControl,
  });

  final IdName? birthControl;
  final IdName? partnerBirthControl;

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
            _shared.sensitiveText(
              widget.birthControl != null
                  ? widget.birthControl!.name
                  : AppLocalizations.of(context)!.noBirthControl,
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
              _shared.sensitiveText(
                widget.birthControl!.name,
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
              _shared.sensitiveText(
                widget.partnerBirthControl!.name,
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
      elevation: 1,
      shadowColor: Colors.transparent,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.birthControl,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: birthControl,
        ),
      ),
    );
  }
}
