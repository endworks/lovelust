import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class PartnerForm extends StatefulWidget {
  const PartnerForm({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerForm> createState() => _PartnerFormState();
}

class _PartnerFormState extends State<PartnerForm> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();
  final ApiService api = getIt<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  bool valid() => nameController.value.text.isNotEmpty;

  void submit() async {
    if (formKey.currentState!.validate()) {
      if (valid()) {
        try {
          Navigator.pop(context);
        } on SocketException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Internet connection!'),
            ),
          );
        } on HttpException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't sign in!"),
            ),
          );
        } on FormatException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bad response format!'),
            ),
          );
        } on Exception {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sign in!'),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                filled: true,
                border: UnderlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter name...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
