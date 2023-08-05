import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lovelust/screens/settings/settings.dart';
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
  late List<Widget> _actions;

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'Settings'),
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Navigator.popUntil(context, (route) {
      _actions = widget.actions ?? [];
      if (route.settings.name == '/') {
        _actions.add(
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
          ),
        );
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      actions: _actions,
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
