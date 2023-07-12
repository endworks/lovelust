import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';

class PartnerItem extends StatefulWidget {
  const PartnerItem({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerItem> createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
  final CommonService _common = getIt<CommonService>();

  void _openPartner() {
    debugPrint('tap partner');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return PartnerDetailsPage(
        partner: widget.partner,
      );
    }));
  }

  Text get title {
    return Text(!_common.privacyMode ? widget.partner.name : 'Hidden',
        style: const TextStyle(fontWeight: FontWeight.w600));
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
    return Text(gender, style: secondaryTextStyle());
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.partner.meetingDate);
  }

  Widget get encounters {
    Color color = Theme.of(context).colorScheme.onSurface;
    if (!_common.monochrome) {
      color = Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.favorite, color: color),
          ),
          TextSpan(
            text: _common
                .getActivityByPartner(widget.partner.id)
                .length
                .toString(),
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle secondaryTextStyle() {
    return const TextStyle(
      fontSize: 13,
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
