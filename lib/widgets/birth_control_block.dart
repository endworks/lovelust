import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';

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
  List<Widget> get birthControl {
    List<Widget> list = [];
    TextStyle style = Theme.of(context).textTheme.titleMedium!;
    if (widget.birthControl == widget.partnerBirthControl) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.birthControl!.name,
                style: style,
              ),
              TextSpan(
                  text: ' ${AppLocalizations.of(context)!.byBoth}',
                  style: Theme.of(context).textTheme.bodyMedium),
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
                TextSpan(
                    text: ' ${AppLocalizations.of(context)!.byMe}',
                    style: Theme.of(context).textTheme.bodyMedium),
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
                TextSpan(
                    text: ' ${AppLocalizations.of(context)!.byPartner}',
                    style: Theme.of(context).textTheme.bodyMedium),
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
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
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
