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
  final SharedService _shared = getIt<SharedService>();
  final ApiService _api = getIt<ApiService>();
  final _nameController = TextEditingController();
  late Gender _gender;
  late BiologicalSex _sex;
  final _notesController = TextEditingController();
  bool _new = true;
  DateTime? _meetingDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _new = widget.partner.id != null && widget.partner.id!.isEmpty;
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
    if (valid) {
      Partner partner = Partner(
        id: _new ? const Uuid().v4() : widget.partner.id,
        sex: _sex,
        gender: _gender,
        name: _nameController.value.text,
        meetingDate: widget.partner.meetingDate,
        notes: _notesController.value.text,
      );
      if (!_shared.isLoggedIn) {
        List<Partner> partners = [..._shared.partners];
        if (!_new) {
          Partner? element = partners.firstWhere((e) => e.id == partner.id);
          int index = partners.indexOf(element);
          partners[index] = partner;
        } else {
          partners.add(partner);
        }
        partners.sort((a, b) => a.meetingDate.isAfter(b.meetingDate) ? -1 : 1);
        if (mounted) {
          setState(() => _shared.partners = partners);
        }

        Navigator.pop(context);
      } else {
        try {
          Future request =
              _new ? _api.postPartner(partner) : _api.patchPartner(partner);
          request.then((value) {
            _api.getPartners().then((value) {
              if (mounted) {
                setState(() => _shared.partners = value);
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
    Color color = Theme.of(context).colorScheme.secondary;
    if (gender == Gender.male) {
      return Icon(
        Icons.male,
        color: color,
      );
    } else if (gender == Gender.female) {
      return Icon(
        Icons.female,
        color: color,
      );
    } else {
      return Icon(
        Icons.transgender,
        color: color,
      );
    }
  }

  Icon iconByBiologicalSex(BiologicalSex gender) {
    Color color = Theme.of(context).colorScheme.secondary;
    if (gender == BiologicalSex.male) {
      return Icon(
        Icons.male,
        color: color,
      );
    } else if (gender == BiologicalSex.female) {
      return Icon(
        Icons.female,
        color: color,
      );
    } else {
      return Icon(
        Icons.transgender,
        color: color,
      );
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

  List<Widget> get fields {
    return [
      ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
              ),
            ),
          ],
        ),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownButtonFormField(
                value: _gender,
                decoration: InputDecoration(
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
          ],
        ),
        leading: iconByGender(_gender),
      ),
      ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownButtonFormField(
                value: _sex,
                decoration: InputDecoration(
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
          ],
        ),
        leading: iconByBiologicalSex(_sex),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.meetingDate),
        leading: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.secondary,
        ),
        trailing: _meetingDate != null
            ? Text(DateFormat.yMMMEd().format(_meetingDate!))
            : null,
        onTap: () => _selectDate(context),
      ),
      ListTile(
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _notesController,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notes,
                ),
              ),
            ),
          ],
        ),
        leading: Icon(
          Icons.text_snippet,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text(widget.partner.id!.isEmpty
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
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).padding.left,
              0,
              MediaQuery.of(context).padding.right,
              MediaQuery.of(context).padding.bottom,
            ),
            sliver: SliverList.builder(
              itemBuilder: (context, index) => fields[index],
              itemCount: fields.length,
            ),
          ),
        ],
      ),
    );
  }
}
