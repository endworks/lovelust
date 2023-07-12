import 'package:dynamic_color/dynamic_color.dart';
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
  final SharedService _common = getIt<SharedService>();

  List<Widget> get birthControl {
    List<Widget> list = [];
    TextStyle style = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
    if (widget.birthControl == widget.partnerBirthControl) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.birthControl!.name,
                style: style,
              ),
              TextSpan(text: ' ${AppLocalizations.of(context)!.byBoth}'),
            ],
          ),
        ),
      );
    } else {
      if (widget.birthControl != null) {
        list.add(
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.birthControl!.name,
                  style: style,
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.byMe}'),
              ],
            ),
          ),
        );
      } else {
        list.add(
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.partnerBirthControl!.name,
                  style: style,
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.byPartner}'),
              ],
            ),
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.cyan.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.medication,
            color: color,
          ),
          Text(
            AppLocalizations.of(context)!.birthControl,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: birthControl,
        ),
      ),
    );
  }
}
