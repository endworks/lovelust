import 'package:flutter/material.dart';

class PartnerAddPage extends StatefulWidget {
  const PartnerAddPage({super.key});

  @override
  State<PartnerAddPage> createState() => _PartnerAddPageState();
}

class _PartnerAddPageState extends State<PartnerAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add partner'),
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
