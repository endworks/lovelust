import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class SafetyBlock extends StatefulWidget {
  const SafetyBlock({super.key, required this.safety});

  final String safety;

  @override
  State<SafetyBlock> createState() => _SafetyBlockState();
}

class _SafetyBlockState extends State<SafetyBlock> {
  final SharedService _common = getIt<SharedService>();

  Widget get safetyNotice {
    if (widget.safety == 'safe') {
      Color color =
          Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: color, size: 18),
              Text(
                AppLocalizations.of(context)!.safe,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(AppLocalizations.of(context)!.safeMsg)
        ],
      );
    } else if (widget.safety == 'unsafe') {
      Color color =
          Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: color, size: 18),
              Text(
                AppLocalizations.of(context)!.unsafe,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(AppLocalizations.of(context)!.unsafeMsg)
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
              Icon(Icons.help, color: color, size: 18),
              Text(
                AppLocalizations.of(context)!.partlyUnsafe,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(AppLocalizations.of(context)!.partlyUnsafeMsg)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.health_and_safety,
            color: color,
          ),
          Text(
            AppLocalizations.of(context)!.safety,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ]),
        subtitle: safetyNotice,
      ),
    );
  }
}
