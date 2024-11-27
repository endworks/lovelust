import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, this.title, this.actions, this.scrolled});

  final Widget? title;
  final List<Widget>? actions;
  final bool? scrolled;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  final SharedService _shared = getIt<SharedService>();

  Color get backgroundColor {
    Color color = Theme.of(context).colorScheme.surface;
    if (widget.scrolled != null && widget.scrolled != false) {
      color = Theme.of(context).colorScheme.surface;
    }
    if (!_shared.material) {
      color = color.withAlpha(204);
    }
    return color;
  }

  FlexibleSpaceBar? get flexibleSpaceBar {
    if (_shared.material) {
      return null;
    }
    return FlexibleSpaceBar(
      background: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: backgroundColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: true,
      floating: true,
      snap: true,
      pinned: true,
      actions: widget.actions,
      title: widget.title,
      centerTitle: false,
      forceMaterialTransparency: !_shared.material,
      elevation: 1,
      flexibleSpace: flexibleSpaceBar,
    );
  }
}
