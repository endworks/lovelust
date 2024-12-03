import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class SocialsBlock extends StatefulWidget {
  const SocialsBlock(
      {super.key,
      required this.phone,
      required this.instagram,
      required this.x,
      required this.snapchat,
      required this.onlyfans});

  final String? phone;
  final String? instagram;
  final String? x;
  final String? snapchat;
  final String? onlyfans;

  @override
  State<SocialsBlock> createState() => _SocialsBlockState();
}

class _SocialsBlockState extends State<SocialsBlock> {
  final SharedService _shared = getIt<SharedService>();

  @override
  Widget build(BuildContext context) {
    List<Widget> socials = [];
    if (widget.phone != null && widget.phone!.isNotEmpty) {
      socials.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.phone}: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _shared.sensitiveText(
              widget.phone!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    if (widget.instagram != null && widget.instagram!.isNotEmpty) {
      socials.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.instagram}: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _shared.sensitiveText(
              widget.instagram!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    if (widget.x != null && widget.x!.isNotEmpty) {
      socials.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.x}: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _shared.sensitiveText(
              widget.x!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    if (widget.snapchat != null && widget.snapchat!.isNotEmpty) {
      socials.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.snapchat}: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _shared.sensitiveText(
              widget.snapchat!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    if (widget.onlyfans != null && widget.onlyfans!.isNotEmpty) {
      socials.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.onlyfans}: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _shared.sensitiveText(
              widget.onlyfans!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.socials,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: socials,
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.person_search,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }
}
