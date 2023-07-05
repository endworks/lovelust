import 'package:flutter/material.dart';
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

  Text title() {
    return Text(widget.partner.name,
        style: const TextStyle(fontWeight: FontWeight.w500));
  }

  Text gender() {
    String gender = 'Non binary';
    if (widget.partner.gender == 'M') {
      if (widget.partner.sex == 'M') {
        gender = 'Man';
      } else {
        gender = 'Trans man';
      }
    } else if (widget.partner.gender == 'F') {
      if (widget.partner.sex == 'F') {
        gender = 'Woman';
      } else {
        gender = 'Trans woman';
      }
    }
    return Text(gender, style: secondaryTextStyle());
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.partner.meetingDate);
  }

  Widget? encounters() {
    return Text(
      _common.getActivityByPartner(widget.partner.id).length.toString(),
      style: const TextStyle(
        color: Colors.red,
        fontSize: 21,
        fontWeight: FontWeight.w600,
      ),
    );
    /*return Row(children: [
        const Icon(Icons.favorite, color: Colors.red),
        Text(
          _common.getActivityByPartner(widget.partner.id).length.toString(),
          style: const TextStyle(color: Colors.red),
        )
      ]);*/
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
        title: title(),
        subtitle: gender(),
        trailing: encounters(),
        onTap: _openPartner);
  }
}
