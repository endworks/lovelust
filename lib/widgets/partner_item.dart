import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';

class PartnerItem extends StatefulWidget {
  const PartnerItem({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerItem> createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
  final SharedService _shared = getIt<SharedService>();

  void _openPartner() {
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

  Widget get title {
    return _shared.sensitiveText(
      widget.partner.name,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Text get gender {
    String gender = AppLocalizations.of(context)!.nonBinary;
    if (widget.partner.gender == Gender.male) {
      if (widget.partner.sex == BiologicalSex.male) {
        gender = AppLocalizations.of(context)!.man;
      } else {
        gender = AppLocalizations.of(context)!.transMan;
      }
    } else if (widget.partner.gender == Gender.female) {
      if (widget.partner.sex == BiologicalSex.female) {
        gender = AppLocalizations.of(context)!.woman;
      } else {
        gender = AppLocalizations.of(context)!.transWoman;
      }
    }
    return Text(
      gender,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
    );
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.partner.meetingDate);
  }

  Widget get encounters {
    Color color =
        Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.favorite, color: color),
        _shared.sensitiveText(
          _shared.getActivityByPartner(widget.partner.id).length.toString(),
          style: TextStyle(
            color: color,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ActivityAvatar(partnerId: widget.partner.id),
      title: title,
      subtitle: gender,
      trailing: encounters,
      onTap: _openPartner,
    );
  }
}
