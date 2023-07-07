import 'package:flutter/material.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, required this.title, required, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(16),
        title: widget.title,
      ),
      actions: widget.actions,
    );
  }
}
