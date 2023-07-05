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
  final genderController = TextEditingController();
  final sexController = TextEditingController();
  final meetingDateController = TextEditingController();
  final notesController = TextEditingController();

  bool get valid =>
      nameController.value.text.isNotEmpty &&
      genderController.value.text.isNotEmpty &&
      sexController.value.text.isNotEmpty;

  void submit() async {
    if (formKey.currentState!.validate()) {
      if (valid) {
        try {
          Partner partner = Partner(
            id: widget.partner.id,
            sex: sexController.value.text,
            gender: genderController.value.text,
            name: nameController.value.text,
            meetingDate: widget.partner.meetingDate,
            notes: notesController.value.text,
            activity: widget.partner.activity,
          );
          return api.patchPartner(partner).then(
            (value) {
              debugPrint(
                value.toString(),
              );
            },
          );
          // Navigator.pop(context);
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
    nameController.value = TextEditingValue(
      text: widget.partner.name,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.partner.name.length),
      ),
    );
    genderController.value = TextEditingValue(
      text: widget.partner.gender,
    );
    sexController.value = TextEditingValue(
      text: widget.partner.sex,
    );
    notesController.value = TextEditingValue(
      text: widget.partner.notes ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.partner.notes ?? '').length),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    sexController.dispose();
    notesController.dispose();
    super.dispose();
  }

  List<DropdownMenuEntry> get genderDropdownMenuEntries {
    return common.genders
        .map(
          (e) => DropdownMenuEntry(
            value: e.id,
            label: e.name,
            leadingIcon: iconByGender(e.id),
          ),
        )
        .toList();
  }

  Icon iconByGender(String gender) {
    if (gender == 'M') {
      return const Icon(Icons.male);
    } else if (gender == 'F') {
      return const Icon(Icons.female);
    } else {
      return const Icon(Icons.transgender);
    }
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownMenu(
              controller: genderController,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                border: UnderlineInputBorder(),
              ),
              label: const Text('Gender'),
              hintText: 'Enter gender...',
              leadingIcon: iconByGender(genderController.value.text),
              dropdownMenuEntries: genderDropdownMenuEntries,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownMenu(
              controller: sexController,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                border: UnderlineInputBorder(),
              ),
              label: const Text('Sex'),
              hintText: 'Enter sex...',
              leadingIcon: iconByGender(sexController.value.text),
              dropdownMenuEntries: genderDropdownMenuEntries,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.note_alt),
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
