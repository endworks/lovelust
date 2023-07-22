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
    double size = Theme.of(context).textTheme.titleMedium!.fontSize!;
    TextStyle style = Theme.of(context).textTheme.titleMedium!;

    if (widget.safety == ActivitySafety.safe) {
      Color color =
          Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.safe,
                style: style,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: size,
                ),
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
                AppLocalizations.of(context)!.unsafe,
                style: style.copyWith(color: color),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.error,
                  color: color,
                  size: size,
                ),
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
                AppLocalizations.of(context)!.partlyUnsafe,
                style: style.copyWith(color: color),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.help,
                  color: color,
                  size: size,
                ),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.partlyUnsafeMsg,
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
      elevation: 1,
      shadowColor: Colors.transparent,
      child: ListTile(
        title: Row(children: [
          Text(
            AppLocalizations.of(context)!.safety,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ]),
        subtitle: safetyNotice,
      ),
    );
  }
}
