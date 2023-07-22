import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoContent extends StatefulWidget {
  const NoContent({super.key, this.message});

  final String? message;

  @override
  State<NoContent> createState() => _NoContentState();
}

class _NoContentState extends State<NoContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        widget.message ?? AppLocalizations.of(context)!.noContent,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
      ),
    );
  }
}
