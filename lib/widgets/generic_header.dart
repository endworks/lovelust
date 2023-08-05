import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, this.title, this.actions});

  final Widget? title;
  final List<Widget>? actions;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  final SharedService _shared = getIt<SharedService>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      actions: widget.actions,
      title: widget.title,
      centerTitle: false,
      forceMaterialTransparency: !_shared.material,
      primary: true,
      flexibleSpace: !_shared.material
          ? FlexibleSpaceBar(
              background: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: !_shared.material
                        ? Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(204)
                        : Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
