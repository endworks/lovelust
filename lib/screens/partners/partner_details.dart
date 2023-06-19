import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partner.name),
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
