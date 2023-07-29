import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return PartnerDetailsPage(
        partner: widget.partner,
      );
    }));
  }

  Widget get name {
    return _shared.sensitiveText(
      widget.partner.name,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget? get encounters {
    TextStyle style = Theme.of(context).textTheme.titleLarge!;
    int count = _shared.getActivityByPartner(widget.partner.id).length;
    if (count == 0) {
      return null;
    }
    Color color = Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite,
          color: color,
          size: style.fontSize,
        ),
        _shared.sensitiveText(
          count.toString(),
          style: style.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }

  Widget? get encountersCount {
    TextStyle style = Theme.of(context).textTheme.titleLarge!;
    int count = _shared.getActivityByPartner(widget.partner.id).length;
    if (count == 0) {
      return null;
    }
    return _shared.sensitiveText(
      count.toString(),
      style: style.copyWith(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget? get lastEncounterDate {
    Activity? lastEncounter =
        _shared.getActivityByPartner(widget.partner.id).firstOrNull;
    String text = AppLocalizations.of(context)!.noSexualActivity;
    if (lastEncounter != null) {
      text = RelativeTime(context).format(lastEncounter.date);
    }
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ActivityAvatar(partnerId: widget.partner.id),
      title: name,
      subtitle: lastEncounterDate,
      trailing: encounters,
      onTap: _openPartner,
    );
  }
}
