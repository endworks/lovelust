import 'package:flutter/material.dart';
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
  bool showNavigationDrawer = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer =
        MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      floating: false,
      pinned: true,
      leading: showNavigationDrawer
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _shared.scaffoldKey.currentState!.openDrawer(),
            )
          : null,
      actions: widget.actions,
      title: widget.title,
    );
  }
}
