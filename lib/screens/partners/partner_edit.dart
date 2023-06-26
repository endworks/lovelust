import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';

class PartnerEditPage extends StatefulWidget {
  const PartnerEditPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerEditPage> createState() => _PartnerEditPageState();
}

class _PartnerEditPageState extends State<PartnerEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit partner'),
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
