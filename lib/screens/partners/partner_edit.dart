import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:uuid/uuid.dart';

class PartnerEditPage extends StatefulWidget {
  const PartnerEditPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerEditPage> createState() => _PartnerEditPageState();
}

class _PartnerEditPageState extends State<PartnerEditPage> {
  final SharedService _common = getIt<SharedService>();
  final ApiService _api = getIt<ApiService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late Gender _gender;
  late BiologicalSex _sex;
  final _notesController = TextEditingController();
  bool _new = true;
  DateTime? _meetingDate;

  @override
  void initState() {
    super.initState();
    _new = widget.partner.id.isEmpty;
    _meetingDate = widget.partner.meetingDate;
    _nameController.value = TextEditingValue(
      text: widget.partner.name,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.partner.name.length),
      ),
    );
    _gender = widget.partner.gender;
    _sex = widget.partner.sex;
    _notesController.value = TextEditingValue(
      text: widget.partner.notes ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.partner.notes ?? '').length),
      ),
    );
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get valid => _nameController.value.text.isNotEmpty;

  void save() {
    if (_formKey.currentState!.validate()) {
      if (valid) {
        Partner partner = Partner(
          id: _new ? const Uuid().v4() : widget.partner.id,
          sex: _sex,
          gender: _gender,
          name: _nameController.value.text,
          meetingDate: widget.partner.meetingDate,
          notes: _notesController.value.text,
        );
        if (!_common.isLoggedIn) {
          List<Partner> partners = [..._common.partners];
          if (widget.partner.id.isNotEmpty) {
            Partner? element = partners.firstWhere((e) => e.id == partner.id);
            int index = partners.indexOf(element);
            partners[index] = partner;
          } else {
            partners.add(partner);
          }
          partners
              .sort((a, b) => a.meetingDate.isAfter(b.meetingDate) ? -1 : 1);
          if (mounted) {
            setState(() => _common.partners = partners);
          }
          Navigator.pop(context);
        } else {
          try {
            Future request =
                _new ? _api.postPartner(partner) : _api.patchPartner(partner);
            request.then((value) {
              _api.getPartners().then((value) {
                if (mounted) {
                  setState(() => _common.partners = value);
                }
                Navigator.pop(context);
              });
            });
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

  List<DropdownMenuItem> get biologicalSexDropdownMenuEntries {
    return [
      DropdownMenuItem(
        value: BiologicalSex.female,
        child: Text(AppLocalizations.of(context)!.female),
      ),
      DropdownMenuItem(
        value: BiologicalSex.male,
        child: Text(AppLocalizations.of(context)!.male),
      )
    ];
  }

  List<DropdownMenuItem> get genderDropdownMenuEntries {
    return [
      DropdownMenuItem(
        value: Gender.female,
        child: Text(AppLocalizations.of(context)!.female),
      ),
      DropdownMenuItem(
        value: Gender.male,
        child: Text(AppLocalizations.of(context)!.male),
      ),
      DropdownMenuItem(
        value: Gender.nonBinary,
        child: Text(AppLocalizations.of(context)!.nonBinary),
      )
    ];
  }

  Icon iconByGender(Gender gender) {
    if (gender == Gender.male) {
      return const Icon(Icons.male);
    } else if (gender == Gender.female) {
      return const Icon(Icons.female);
    } else {
      return const Icon(Icons.transgender);
    }
  }

  Icon iconByBiologicalSex(BiologicalSex gender) {
    if (gender == BiologicalSex.male) {
      return const Icon(Icons.male);
    } else if (gender == BiologicalSex.female) {
      return const Icon(Icons.female);
    } else {
      return const Icon(Icons.transgender);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: _meetingDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != _meetingDate) {
      setState(() {
        _meetingDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text(widget.partner.id.isEmpty
                ? AppLocalizations.of(context)!.createPartner
                : AppLocalizations.of(context)!.editPartner),
            actions: [
              FilledButton(
                onPressed: valid ? save : null,
                child: Text(AppLocalizations.of(context)!.save),
              ),
              PopupMenuButton(
                onSelected: (MenuEntryItem item) {},
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuEntryItem>>[
                  PopupMenuItem(
                    value: MenuEntryItem.help,
                    child: Text(AppLocalizations.of(context)!.help),
                  ),
                ],
              ),
            ],
          ),
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField(
                  value: _gender,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: iconByGender(_gender),
                    labelText: AppLocalizations.of(context)!.gender,
                  ),
                  items: genderDropdownMenuEntries,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField(
                  value: _sex,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: iconByBiologicalSex(_sex),
                    labelText: AppLocalizations.of(context)!.sex,
                  ),
                  items: biologicalSexDropdownMenuEntries,
                  onChanged: (value) {
                    setState(() {
                      _sex = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.meetingDate),
                leading: Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                trailing: _meetingDate != null
                    ? Text(DateFormat('EEE, MMM d').format(_meetingDate!))
                    : null,
                onTap: () => _selectDate(context),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _notesController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.note_alt),
                    labelText: AppLocalizations.of(context)!.notes,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
