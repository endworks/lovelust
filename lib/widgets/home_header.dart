import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    bool pinned = true;
    bool snap = false;
    bool floating = false;

    return SliverAppBar.medium(
      pinned: pinned,
      snap: snap,
      floating: floating,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('SliverAppBar'),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
