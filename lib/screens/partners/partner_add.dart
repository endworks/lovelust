import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';

class PartnerAddPage extends StatefulWidget {
  const PartnerAddPage({super.key});

  @override
  State<PartnerAddPage> createState() => _PartnerAddPageState();
}

class _PartnerAddPageState extends State<PartnerAddPage> {
  Partner partner = Partner(
    id: '',
    sex: 'F',
    gender: 'F',
    name: '',
    meetingDate: DateTime.now(),
    notes: null,
    activity: null,
  );

  @override
  Widget build(BuildContext context) {
    return PartnerEditPage(partner: partner);
  }
}
