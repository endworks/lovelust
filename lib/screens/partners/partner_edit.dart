import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';

class PartnerEditPage extends StatefulWidget {
  const PartnerEditPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerEditPage> createState() => _PartnerEditPageState();
}

class _PartnerEditPageState extends State<PartnerEditPage> {
  final CommonService common = getIt<CommonService>();
  final ApiService api = getIt<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final sexController = TextEditingController();
  final meetingDateController = TextEditingController();
  final notesController = TextEditingController();

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
    nameController.addListener(() => setState(() {}));
    genderController.addListener(() => setState(() {}));
    sexController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    sexController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get valid =>
      nameController.value.text.isNotEmpty &&
      genderController.value.text.isNotEmpty &&
      sexController.value.text.isNotEmpty;

  void save() {
    if (formKey.currentState!.validate()) {
      if (valid) {
        Partner partner = Partner(
          id: widget.partner.id,
          sex: sexController.value.text,
          gender: genderController.value.text,
          name: nameController.value.text,
          meetingDate: widget.partner.meetingDate,
          notes: notesController.value.text,
          activity: [],
        );
        if (!common.isLoggedIn) {
          if (widget.partner.id.isNotEmpty) {
            Partner element =
                common.partners.firstWhere((e) => e.id == partner.id);
            int index = common.partners.indexOf(element);
            common.partners[index] = partner;
          } else {
            common.partners.add(partner);
          }
          Navigator.pop(context);
        } else {
          try {
            debugPrint('partner: ${partner.toJson().toString()}');
            if (widget.partner.id.isNotEmpty) {
              api.patchPartner(partner).then((value) => Navigator.pop(context));
            } else {
              api.postPartner(partner).then((value) => Navigator.pop(context));
            }
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
    if (gender == 'M' || gender == 'Male') {
      return const Icon(Icons.male);
    } else if (gender == 'F' || gender == 'Female') {
      return const Icon(Icons.female);
    } else {
      return const Icon(Icons.transgender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.partner.id.isEmpty ? 'Create partner' : 'Edit partner'),
        actions: [
          FilledButton(
            onPressed: valid ? save : null,
            child: const Text('Save'),
          ),
          PopupMenuButton(
            onSelected: (MenuEntryItem item) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuEntryItem>>[
              const PopupMenuItem(
                value: MenuEntryItem.help,
                child: Text('Help'),
              ),
            ],
          ),
        ],
      ),
      body: Form(
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
                leadingIcon: iconByGender(genderController.text),
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
                leadingIcon: iconByGender(sexController.text),
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
      ),
    );
  }
}
