import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';
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
  final IdName? initiator;

  @override
  State<PerformanceBlock> createState() => _PerformanceBlockState();
}

class _PerformanceBlockState extends State<PerformanceBlock> {
  final SharedService _common = getIt<SharedService>();

  List<Widget> get performance {
    List<Widget> list = [];
    TextStyle style = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
    );

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
                      ' ${AppLocalizations.of(context)!.orgasmsByMe(widget.orgasms)}'),
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
                      ' ${AppLocalizations.of(context)!.orgasmsByPartner(widget.partnerOrgasms)}'),
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
              TextSpan(text: ' ${AppLocalizations.of(context)!.initiatedIt}'),
            ],
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.deepOrange.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.tag_faces,
            color: color,
          ),
          Text(
            AppLocalizations.of(context)!.performance,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: performance,
        ),
      ),
    );
  }
}
