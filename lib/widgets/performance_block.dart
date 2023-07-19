import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';

class PerformanceBlock extends StatefulWidget {
  const PerformanceBlock(
      {super.key,
      required this.orgasms,
      required this.partnerOrgasms,
      required this.initiator});

  final int orgasms;
  final int partnerOrgasms;
  final IdName? initiator;

  @override
  State<PerformanceBlock> createState() => _PerformanceBlockState();
}

class _PerformanceBlockState extends State<PerformanceBlock> {
  List<Widget> get performance {
    List<Widget> list = [];
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    if (widget.orgasms > 0) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.orgasms.toString(),
                style: style,
              ),
              TextSpan(
                  text:
                      ' ${AppLocalizations.of(context)!.orgasmsByMe(widget.orgasms)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    if (widget.partnerOrgasms > 0) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.partnerOrgasms.toString(),
                style: style,
              ),
              TextSpan(
                  text:
                      ' ${AppLocalizations.of(context)!.orgasmsByPartner(widget.partnerOrgasms)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    if (widget.initiator != null) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.initiator!.name,
                style: style,
              ),
              TextSpan(
                  text: ' ${AppLocalizations.of(context)!.initiatedIt}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
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
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.performance,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: performance,
        ),
      ),
    );
  }
}
