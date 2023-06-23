import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_details.dart';
import 'package:lovelust/widgets/activity_avatar.dart';

class PartnerItem extends StatefulWidget {
  const PartnerItem({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerItem> createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
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
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.partner.sex == 'M'
                ? Colors.blue[400]
                : Colors.red[400]));
  }

  String date() {
    return DateFormat('dd MMMM yyyy').format(widget.partner.meetingDate);
  }

  Widget? encounters() {
    if (widget.partner.activity != null) {
      Text(
        widget.partner.activity!.length.toString(),
        style: const TextStyle(color: Colors.red),
      );
      /*return Row(children: [
        const Icon(Icons.favorite, color: Colors.red),
        Text(
          widget.partner.activity!.length.toString(),
          style: const TextStyle(color: Colors.red),
        )
      ]);*/
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ActivityAvatar(partnerId: widget.partner.id),
        title: title(),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              Icons.event_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Text(date())),
          ]),
        ]),
        trailing: encounters(),
        onTap: _openPartner);
  }
}
