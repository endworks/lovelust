import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PracticesBlock extends StatefulWidget {
  const PracticesBlock({super.key, required this.practices});

  final List<IdName> practices;

  @override
  State<PracticesBlock> createState() => _PracticesBlockState();
}

class _PracticesBlockState extends State<PracticesBlock> {
  final SharedService _common = getIt<SharedService>();

  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.blue.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.task_alt,
            color: color,
          ),
          Text(
            AppLocalizations.of(context)!.practices,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ]),
        subtitle: Text(widget.practices.map((e) => e.name).join(', ')),
      ),
    );
  }
}
