import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class PerformanceBlock extends StatefulWidget {
  const PerformanceBlock(
      {super.key,
      required this.orgasms,
      required this.partnerOrgasms,
      required this.initiator});

  final int orgasms;
  final int partnerOrgasms;
  final IdName initiator;

  @override
  State<PerformanceBlock> createState() => _PerformanceBlockState();
}

class _PerformanceBlockState extends State<PerformanceBlock> {
  final CommonService _common = getIt<CommonService>();

  List<Widget> get performance {
    List<Widget> list = [];

    if (widget.orgasms > 0) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.orgasms.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const TextSpan(text: ' orgasms by me'),
            ],
          ),
        ),
      );
    } else if (widget.partnerOrgasms > 0) {
      list.add(
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.partnerOrgasms.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const TextSpan(text: ' orgasms by partner'),
            ],
          ),
        ),
      );
    }

    list.add(
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.initiator.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const TextSpan(text: ' initiated it'),
          ],
        ),
      ),
    );

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
            'Performance',
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
