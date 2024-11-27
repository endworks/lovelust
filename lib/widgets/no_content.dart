import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';

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
  double alpha = 0.4;
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme.onSurface.withOpacity(alpha);

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
              color: color,
            ),
            Text(
              widget.message ?? AppLocalizations.of(context)!.noContent,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
            widget.action != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: FilledButton.tonal(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(color),
                        side: WidgetStateBorderSide.resolveWith(
                          (states) => BorderSide(
                            width: 1,
                            color: color,
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.transparent,
                        ),
                      ),
                      onPressed: widget.action,
                      child: Text(widget.actionLabel ?? 'Retry'),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
