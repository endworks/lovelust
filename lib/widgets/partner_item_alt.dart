import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';
import 'package:relative_time/relative_time.dart';

class PartnerItemAlt extends StatefulWidget {
  const PartnerItemAlt({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerItemAlt> createState() => _PartnerItemAltState();
}

class _PartnerItemAltState extends State<PartnerItemAlt> {
  final SharedService _shared = getIt<SharedService>();

  void _openPartner() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'PartnerDetails'),
        builder: (BuildContext context) => PartnerDetailsPage(
          partner: widget.partner,
        ),
      ),
    );
  }

  Widget get name {
    return _shared.privacyRedactedText(
      widget.partner.name,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget? get encounters {
    TextStyle style = Theme.of(context).textTheme.titleLarge!;
    int count = _shared.getActivityByPartner(widget.partner.id!).length;
    if (count == 0) {
      return null;
    }
    Color color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: style.copyWith(
            color: color,
          ),
        ),
        Icon(
          Icons.favorite,
          color: color,
          size: style.fontSize,
        ),
      ],
    );
  }

  Widget? get lastEncounterDate {
    Activity? lastEncounter =
        _shared.getActivityByPartner(widget.partner.id!).firstOrNull;
    String text = AppLocalizations.of(context)!.noSexualActivity;
    if (lastEncounter != null) {
      text = RelativeTime(context).format(lastEncounter.date);
    }
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ObjectKey(widget.partner.id),
      leading: ActivityAvatar(partnerId: widget.partner.id),
      title: name,
      subtitle: lastEncounterDate,
      trailing: encounters,
      onTap: _openPartner,
    );
  }
}
