import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoContent extends StatefulWidget {
  const NoContent(
      {super.key, this.icon, this.message, this.action, this.actionLabel});

  final IconData? icon;
  final String? message;
  final void Function()? action;
  final String? actionLabel;

  @override
  State<NoContent> createState() => _NoContentState();
}

class _NoContentState extends State<NoContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon ?? Icons.hide_source,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            Text(
              widget.message ?? AppLocalizations.of(context)!.noContent,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            widget.action != null
                ? FilledButton.tonal(
                    onPressed: widget.action,
                    child: Text(widget.actionLabel ?? 'Retry'),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
