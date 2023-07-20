import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
  final SharedService _common = getIt<SharedService>();

  void _openPartner() {
    debugPrint('tap partner');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return PartnerDetailsPage(
        partner: widget.partner,
      );
    }));
  }

  Widget get title {
    return _common.sensitiveText(
      widget.partner.name,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Text get gender {
    String gender = AppLocalizations.of(context)!.nonBinary;
    if (widget.partner.gender == 'M') {
      if (widget.partner.sex == 'M') {
        gender = AppLocalizations.of(context)!.man;
      } else {
        gender = AppLocalizations.of(context)!.transMan;
      }
    } else if (widget.partner.gender == 'F') {
      if (widget.partner.sex == 'F') {
        gender = AppLocalizations.of(context)!.woman;
      } else {
        gender = AppLocalizations.of(context)!.transWoman;
      }
    }
    return Text(gender, style: Theme.of(context).textTheme.bodyMedium);
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.partner.meetingDate);
  }

  Widget get encounters {
    Color color = Theme.of(context).colorScheme.onSurface;
    if (!_common.monochrome) {
      color = Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(Icons.favorite, color: color),
        _common.sensitiveText(
          _common.getActivityByPartner(widget.partner.id).length.toString(),
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
