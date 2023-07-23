import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PerformanceBlock extends StatefulWidget {
  const PerformanceBlock(
      {super.key,
      required this.orgasms,
      required this.partnerOrgasms,
      required this.initiator});

  final int orgasms;
  final int partnerOrgasms;
  final Initiator? initiator;

  @override
  State<PerformanceBlock> createState() => _PerformanceBlockState();
}

class _PerformanceBlockState extends State<PerformanceBlock> {
  final SharedService _shared = getIt<SharedService>();

  List<Widget> get performance {
    List<Widget> list = [];
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    if (widget.orgasms > 0) {
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _shared.sensitiveText(
              widget.orgasms.toString(),
              style: style,
            ),
            Text(
                ' ${AppLocalizations.of(context)!.orgasmsByMe(widget.orgasms)}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (widget.partnerOrgasms > 0) {
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _shared.sensitiveText(
              widget.partnerOrgasms.toString(),
              style: style,
            ),
            Text(
                ' ${AppLocalizations.of(context)!.orgasmsByPartner(widget.partnerOrgasms)}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (widget.initiator != null) {
      String initiatorString = AppLocalizations.of(context)!.both;
      String initiatorValue = 'both';
      if (widget.initiator == Initiator.me) {
        initiatorString = AppLocalizations.of(context)!.me;
        initiatorValue = 'me';
      } else if (widget.initiator == Initiator.partner) {
        initiatorString = AppLocalizations.of(context)!.partner;
        initiatorValue = 'partner';
      }
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _shared.sensitiveText(
              initiatorString,
              style: style,
            ),
            Text(
                ' ${AppLocalizations.of(context)!.initiatedIt(initiatorValue)}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
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
          AppLocalizations.of(context)!.performance,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: performance,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.whatshot,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
