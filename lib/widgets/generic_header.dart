import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, required this.title, required this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  final CommonService _common = getIt<CommonService>();

  Color get headerForegroundColor {
    return Theme.of(context).colorScheme.inverseSurface;
  }

  Color get headerBackgroundColor {
    return Theme.of(context)
        .colorScheme
        .surfaceVariant
        .withAlpha(_common.alpha);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 128,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 72,
          bottom: 16,
          end: 88,
        ),
        background: DecoratedBox(
          decoration: BoxDecoration(color: headerBackgroundColor),
        ),
        title: widget.title,
      ),
      actions: widget.actions,
    );
  }
}
