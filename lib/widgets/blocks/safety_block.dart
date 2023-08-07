import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';

class SafetyBlock extends StatefulWidget {
  const SafetyBlock({super.key, required this.safety});

  final ActivitySafety safety;

  @override
  State<SafetyBlock> createState() => _SafetyBlockState();
}

class _SafetyBlockState extends State<SafetyBlock> {
  Widget get safetyNotice {
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    if (widget.safety == ActivitySafety.safe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.safeSex,
                style: style,
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.safeMsg,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      );
    } else if (widget.safety == ActivitySafety.unsafe) {
      Color color =
          Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.unsafeSex,
                style: style.copyWith(color: color),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.unsafeMsg,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      );
    } else {
      Color color =
          Colors.orange.harmonizeWith(Theme.of(context).colorScheme.primary);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.partiallyUnsafeSex,
                style: style.copyWith(color: color),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.partiallyUnsafeMsg,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        title: safetyNotice,
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.health_and_safety,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
