import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  void editPartner() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return PartnerEditPage(partner: widget.partner);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partner.name),
        actions: [
          IconButton(onPressed: editPartner, icon: const Icon(Icons.edit))
        ],
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
