import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class NotesBlock extends StatefulWidget {
  const NotesBlock({super.key, required this.notes});

  final String notes;

  @override
  State<NotesBlock> createState() => _NotesBlockState();
}

class _NotesBlockState extends State<NotesBlock> {
  final CommonService _common = getIt<CommonService>();

  @override
  Widget build(BuildContext context) {
    Color color =
        Colors.amber.harmonizeWith(Theme.of(context).colorScheme.primary);
    return Card(
      elevation: 0,
      color:
          Theme.of(context).colorScheme.surfaceVariant.withAlpha(_common.alpha),
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(children: [
          Icon(
            Icons.note_alt,
            color: color,
          ),
          Text(
            'Notes',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ]),
        subtitle: Text(widget.notes),
      ),
    );
  }
}
