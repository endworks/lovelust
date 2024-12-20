import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/widgets/partner_item_alt.dart';

class PartnerCard extends StatefulWidget {
  const PartnerCard({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends State<PartnerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: PartnerItemAlt(partner: widget.partner),
    );
  }
}
