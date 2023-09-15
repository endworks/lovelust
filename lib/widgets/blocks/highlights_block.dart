import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class HighlightsBlock extends StatefulWidget {
  const HighlightsBlock({
    super.key,
    required this.orgasms,
    required this.partnerOrgasms,
    required this.initiator,
    required this.mood,
  });

  final int orgasms;
  final int partnerOrgasms;
  final Initiator? initiator;
  final Mood? mood;

  @override
  State<HighlightsBlock> createState() => _HighlightsBlockState();
}

class _HighlightsBlockState extends State<HighlightsBlock> {
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
            Text(
              widget.orgasms.toString(),
              style: style,
            ),
            _shared.inappropriateText(
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
            Text(
              widget.partnerOrgasms.toString(),
              style: style,
            ),
            _shared.inappropriateText(
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
            Text(
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

    if (widget.mood != null) {
      list.add(
        FilterChip(
          label: Text(
            SharedService.getMoodTranslation(widget.mood),
          ),
          /* avatar: _shared.sensitiveText(
            SharedService.getMoodEmoji(widget.mood),
          ),*/
          selected: true,
          onSelected: (value) {},
          showCheckmark: false,
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
          AppLocalizations.of(context)!.highlights,
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
