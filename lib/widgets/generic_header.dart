import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  final SharedService _shared = getIt<SharedService>();

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      actions: [
        ...(widget.actions ?? []),
        IconButton(
          onPressed: _openSettings,
          icon: const Icon(Icons.settings),
        )
      ],
      title: widget.title,
      centerTitle: false,
      forceMaterialTransparency: true,
      primary: true,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: !_shared.material
                  ? Theme.of(context).colorScheme.background.withAlpha(204)
                  : Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
