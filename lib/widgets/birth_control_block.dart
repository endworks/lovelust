import 'package:dynamic_color/dynamic_color.dart';
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

  String getContraceptiveName(Contraceptive? contraceptive) {
    if (contraceptive == Contraceptive.condom) {
      return AppLocalizations.of(context)!.condom;
    } else if (contraceptive == Contraceptive.cervicalCap) {
      return AppLocalizations.of(context)!.cervicalCap;
    } else if (contraceptive == Contraceptive.contraceptiveImplant) {
      return AppLocalizations.of(context)!.contraceptiveImplant;
    } else if (contraceptive == Contraceptive.contraceptivePatch) {
      return AppLocalizations.of(context)!.contraceptivePatch;
    } else if (contraceptive == Contraceptive.contraceptiveShot) {
      return AppLocalizations.of(context)!.contraceptiveShot;
    } else if (contraceptive == Contraceptive.diaphragm) {
      return AppLocalizations.of(context)!.diaphragm;
    } else if (contraceptive == Contraceptive.infertility) {
      return AppLocalizations.of(context)!.infertility;
    } else if (contraceptive == Contraceptive.internalCondom) {
      return AppLocalizations.of(context)!.internalCondom;
    } else if (contraceptive == Contraceptive.intrauterineDevice) {
      return AppLocalizations.of(context)!.intrauterineDevice;
    } else if (contraceptive == Contraceptive.outercourse) {
      return AppLocalizations.of(context)!.outercourse;
    } else if (contraceptive == Contraceptive.pill) {
      return AppLocalizations.of(context)!.pill;
    } else if (contraceptive == Contraceptive.sponge) {
      return AppLocalizations.of(context)!.sponge;
    } else if (contraceptive == Contraceptive.tubalLigation) {
      return AppLocalizations.of(context)!.tubalLigation;
    } else if (contraceptive == Contraceptive.unsafeContraceptive) {
      return AppLocalizations.of(context)!.unsafeContraceptive;
    } else if (contraceptive == Contraceptive.vaginalRing) {
      return AppLocalizations.of(context)!.vaginalRing;
    } else if (contraceptive == Contraceptive.vasectomy) {
      return AppLocalizations.of(context)!.vasectomy;
    }
    return AppLocalizations.of(context)!.noBirthControl;
  }

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
              getContraceptiveName(widget.birthControl),
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
                getContraceptiveName(widget.birthControl),
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
                getContraceptiveName(widget.partnerBirthControl),
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
            color: Colors.cyan
                .harmonizeWith(Theme.of(context).colorScheme.primary),
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
