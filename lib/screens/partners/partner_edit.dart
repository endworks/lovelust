import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:uuid/uuid.dart';

class PartnerEditPage extends StatefulWidget {
  const PartnerEditPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerEditPage> createState() => _PartnerEditPageState();
}

class _PartnerEditPageState extends State<PartnerEditPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _sexController = TextEditingController();
  final _notesController = TextEditingController();
  bool _new = true;

  @override
  void initState() {
    super.initState();
    _new = widget.partner.id.isEmpty;
    _nameController.value = TextEditingValue(
      text: widget.partner.name,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.partner.name.length),
      ),
    );
    _genderController.value = TextEditingValue(
      text: widget.partner.gender,
    );
    _sexController.value = TextEditingValue(
      text: widget.partner.sex,
    );
    _notesController.value = TextEditingValue(
      text: widget.partner.notes ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.partner.notes ?? '').length),
      ),
    );
    _nameController.addListener(() => setState(() {}));
    _genderController.addListener(() => setState(() {}));
    _sexController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _sexController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get valid =>
      _nameController.value.text.isNotEmpty &&
      _genderController.value.text.isNotEmpty &&
      _sexController.value.text.isNotEmpty;

  void save() {
    if (_formKey.currentState!.validate()) {
      if (valid) {
        Partner partner = Partner(
          id: _new ? const Uuid().v4() : widget.partner.id,
          sex: _sexController.value.text,
          gender: _genderController.value.text,
          name: _nameController.value.text,
          meetingDate: widget.partner.meetingDate,
          notes: _notesController.value.text,
          activity: [],
        );
        if (!_common.isLoggedIn) {
          if (widget.partner.id.isNotEmpty) {
            List<Partner> partners = [..._common.partners];
            Partner element = partners.firstWhere((e) => e.id == partner.id);
            int index = partners.indexOf(element);
            partners[index] = partner;
            setState(() {
              _common.partners = partners;
            });
          } else {
            List<Partner> partners = [..._common.partners];
            partners.add(partner);
            setState(() {
              _common.partners = partners;
            });
          }
          Navigator.pop(context);
        } else {
          try {
            debugPrint('partner: ${partner.toJson().toString()}');
            if (_new) {
              _api.postPartner(partner).then((value) => Navigator.pop(context));
            } else {
              _api
                  .patchPartner(partner)
                  .then((value) => Navigator.pop(context));
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

  List<DropdownMenuItem> get genderDropdownMenuEntries {
    return _common.genders
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
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
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  labelText: 'Name',
                  hintText: 'Enter name...',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField(
                value: _genderController.text,
                decoration: InputDecoration(
                  prefixIcon: iconByGender(_genderController.text),
                  filled: true,
                  labelText: 'Gender',
                  hintText: 'Enter gender...',
                ),
                items: genderDropdownMenuEntries,
                onChanged: (value) {
                  _genderController.text = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField(
                value: _sexController.text,
                decoration: InputDecoration(
                  prefixIcon: iconByGender(_sexController.text),
                  filled: true,
                  labelText: 'Sex',
                  hintText: 'Enter sex...',
                ),
                items: genderDropdownMenuEntries,
                onChanged: (value) {
                  _sexController.text = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _notesController,
                maxLines: null,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.note_alt),
                  filled: true,
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
