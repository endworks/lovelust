import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool pinned = true;
    bool snap = false;
    bool floating = false;

    return SliverAppBar(
      pinned: pinned,
      snap: snap,
      floating: floating,
      expandedHeight: 100.0,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('SliverAppBar'),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
