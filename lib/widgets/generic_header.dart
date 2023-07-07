import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class GenericHeader extends StatefulWidget {
  const GenericHeader({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  State<GenericHeader> createState() => _GenericHeaderState();
}

class _GenericHeaderState extends State<GenericHeader> {
  final CommonService _common = getIt<CommonService>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      floating: false,
      pinned: true,
      actions: widget.actions,
      title: widget.title,
    );
  }
}
