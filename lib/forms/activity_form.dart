import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();
  final ApiService api = getIt<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  final passwordController = TextEditingController();

  bool valid() =>
      notesController.value.text.isNotEmpty &&
      passwordController.value.text.isNotEmpty;

  void submit() async {
    if (formKey.currentState!.validate()) {
      if (valid()) {
        try {
          await api.postActivity(widget.activity);
          List<Activity> result = await api.getActivity();
          storage.setActivity(result);
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
    notesController.dispose();
    passwordController.dispose();
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
              controller: notesController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.note),
                filled: true,
                border: UnderlineInputBorder(),
                labelText: 'Notes',
                hintText: 'Enter notes...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
