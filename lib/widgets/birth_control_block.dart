import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

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
  final CommonService _common = getIt<CommonService>();

  List<Widget> get birthControl {
    List<Widget> list = [];
    if (widget.birthControl == widget.partnerBirthControl) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.birthControl!.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const TextSpan(text: ' by both'),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(text: ' by me'),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(text: ' by partner'),
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
            'Birth control',
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
