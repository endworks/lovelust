import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:uuid/uuid.dart';

class ActivityEditPage extends StatefulWidget {
  const ActivityEditPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  final SharedService _common = getIt<SharedService>();
  final ApiService _api = getIt<ApiService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _partnerController = TextEditingController();
  final _birthControlController = TextEditingController();
  final _partnerBirthControlController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();
  final _orgasmsController = TextEditingController();
  final _partnerOrgasmsController = TextEditingController();
  final _placeController = TextEditingController();
  final _initiatorController = TextEditingController();
  final _ratingController = TextEditingController();
  final _typeController = TextEditingController();

  bool _new = true;

  @override
  void initState() {
    super.initState();
    _new = widget.activity.id.isEmpty;
    _typeController.value = TextEditingValue(
      text: widget.activity.type ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.type ?? '').length),
      ),
    );
    _partnerController.value = TextEditingValue(
      text: widget.activity.partner ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.partner ?? '').length),
      ),
    );
    _birthControlController.value = TextEditingValue(
      text: widget.activity.birthControl ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.birthControl ?? '').length),
      ),
    );
    _partnerBirthControlController.value = TextEditingValue(
      text: widget.activity.partnerBirthControl ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
            offset: (widget.activity.partnerBirthControl ?? '').length),
      ),
    );
    _locationController.value = TextEditingValue(
      text: widget.activity.location ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.location ?? '').length),
      ),
    );
    _notesController.value = TextEditingValue(
      text: widget.activity.notes ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.notes ?? '').length),
      ),
    );
    _durationController.value = TextEditingValue(
      text: widget.activity.duration.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.activity.duration.toString().length),
      ),
    );
    _orgasmsController.value = TextEditingValue(
      text: widget.activity.orgasms.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.activity.orgasms.toString().length),
      ),
    );
    _partnerOrgasmsController.value = TextEditingValue(
      text: widget.activity.partnerOrgasms.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.activity.partnerOrgasms.toString().length),
      ),
    );
    _placeController.value = TextEditingValue(
      text: widget.activity.place ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.place ?? '').length),
      ),
    );
    _initiatorController.value = TextEditingValue(
      text: widget.activity.initiator ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(offset: (widget.activity.initiator ?? '').length),
      ),
    );
    _ratingController.value = TextEditingValue(
      text: widget.activity.rating.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.activity.rating.toString().length),
      ),
    );
  }

  @override
  void dispose() {
    _partnerController.dispose();
    _birthControlController.dispose();
    _partnerBirthControlController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    _orgasmsController.dispose();
    _partnerOrgasmsController.dispose();
    _placeController.dispose();
    _initiatorController.dispose();
    _ratingController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  bool get valid => true;

  List<DropdownMenuItem> get typeDropdownMenuEntries {
    return _common.activityTypes
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem> get partnerDropdownMenuEntries {
    var list = _common.partners
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
    list.add(DropdownMenuItem(
      value: '',
      child: Text(AppLocalizations.of(context)!.unknownPartner),
    ));
    return list;
  }

  List<DropdownMenuItem> get birthControlDropdownMenuEntries {
    var list = _common.birthControls
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
    list.add(DropdownMenuItem(
      value: '',
      child: Text(AppLocalizations.of(context)!.noBirthControl),
    ));
    return list;
  }

  List<DropdownMenuItem> get placeDropdownMenuEntries {
    var list = _common.places
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
    list.add(DropdownMenuItem(
      value: '',
      child: Text(AppLocalizations.of(context)!.unknownPlace),
    ));
    return list;
  }

  List<DropdownMenuItem> get initiatorDropdownMenuEntries {
    var list = _common.initiators
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
    list.add(DropdownMenuItem(
      value: '',
      child: Text(AppLocalizations.of(context)!.noInitiator),
    ));
    return list;
  }

  void save() {
    if (_formKey.currentState!.validate()) {
      if (valid) {
        Activity activity = Activity(
          id: _new ? const Uuid().v4() : widget.activity.id,
          birthControl: _birthControlController.value.text,
          date: DateTime.parse(_dateController.value.text),
          duration: int.parse(_durationController.value.text),
          initiator: _initiatorController.value.text,
          location: _locationController.value.text,
          orgasms: int.parse(_orgasmsController.value.text),
          partner: _partnerController.value.text,
          partnerBirthControl: _partnerBirthControlController.value.text,
          partnerOrgasms: int.parse(_partnerOrgasmsController.value.text),
          place: _placeController.value.text,
          practices: [],
          rating: int.parse(_ratingController.value.text),
          notes: _notesController.value.text,
          type: _typeController.value.text,
          safety: null,
        );
        if (!_common.isLoggedIn) {
          if (widget.activity.id.isNotEmpty) {
            List<Activity> activities = [..._common.activity];
            Activity element =
                activities.firstWhere((e) => e.id == activity.id);
            int index = activities.indexOf(element);
            activities[index] = activity;
            setState(() {
              _common.activity = activities;
            });
          } else {
            List<Activity> activities = [..._common.activity];
            activities.add(activity);
            setState(() {
              _common.activity = activities;
            });
          }
          Navigator.pop(context);
        } else {
          try {
            debugPrint('activity: ${activity.toJson().toString()}');
            if (_new) {
              _api
                  .postActivity(activity)
                  .then((value) => Navigator.pop(context));
            } else {
              _api
                  .patchActivity(activity)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text(widget.activity.id.isEmpty
                ? AppLocalizations.of(context)!.logActivity
                : AppLocalizations.of(context)!.editActivity),
            actions: [
              FilledButton(
                  onPressed: save,
                  child: Text(AppLocalizations.of(context)!.save)),
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
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _typeController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.favorite),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.activityType,
                        ),
                        items: typeDropdownMenuEntries,
                        onChanged: (value) {
                          _typeController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _partnerController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.partner,
                        ),
                        items: partnerDropdownMenuEntries,
                        onChanged: (value) {
                          _partnerController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _birthControlController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.medication),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.birthControl,
                        ),
                        items: birthControlDropdownMenuEntries,
                        onChanged: (value) {
                          _birthControlController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _partnerBirthControlController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.medication),
                          filled: true,
                          labelText:
                              AppLocalizations.of(context)!.partnerBirthControl,
                        ),
                        items: birthControlDropdownMenuEntries,
                        onChanged: (value) {
                          _partnerBirthControlController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _initiatorController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.start),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.initiator,
                        ),
                        items: initiatorDropdownMenuEntries,
                        onChanged: (value) {
                          _initiatorController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField(
                        value: _placeController.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.place),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.place,
                        ),
                        items: placeDropdownMenuEntries,
                        onChanged: (value) {
                          _placeController.text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _locationController,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.map),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.location,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _notesController,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.note_alt),
                          filled: true,
                          labelText: AppLocalizations.of(context)!.notes,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
