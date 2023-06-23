import 'package:flutter/material.dart';

class BigHeader extends StatefulWidget implements PreferredSizeWidget {
  const BigHeader({Key? key, required this.title, this.actions})
      : super(key: key);

  final Widget title;
  final List<Widget>? actions;

  @override
  State<BigHeader> createState() => _BigHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _BigHeaderState extends State<BigHeader> {
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
      flexibleSpace: FlexibleSpaceBar(
        title: widget.title,
      ),
      actions: widget.actions,
    );
  }
}
