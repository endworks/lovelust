import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/rating_select.dart';
import 'package:uuid/uuid.dart';

class ActivityEditPage extends StatefulWidget {
  const ActivityEditPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  final SharedService _shared = getIt<SharedService>();
  final ApiService _api = getIt<ApiService>();

  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();
  final _orgasmsController = TextEditingController();
  final _partnerOrgasmsController = TextEditingController();
  final _ratingController = TextEditingController();

  ActivityType? _type;
  DateTime? _date;
  String? _partner;
  Contraceptive? _birthControl;
  Contraceptive? _partnerBirthControl;
  Place? _place;
  List<Practice> _practices = [];
  Initiator? _initiator;
  Mood? _mood;

  bool _new = true;
  bool _moreFields = false;

  @override
  void initState() {
    super.initState();
    _new = widget.activity.id != null && widget.activity.id!.isEmpty;
    _type = widget.activity.type;
    _date = widget.activity.date;
    _partner = widget.activity.partner;
    _birthControl = widget.activity.birthControl;
    _partnerBirthControl = widget.activity.partnerBirthControl;
    _place = widget.activity.place;
    _practices = widget.activity.practices ?? [];
    _initiator = widget.activity.initiator;
    _mood = widget.activity.mood;

    _dateController.value = TextEditingValue(
      text: widget.activity.date.toIso8601String(),
    );
    _partner = widget.activity.partner;
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

    _ratingController.value = TextEditingValue(
      text: widget.activity.rating.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.activity.rating.toString().length),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _durationController.dispose();
    _orgasmsController.dispose();
    _partnerOrgasmsController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  bool get valid => true;

  List<DropdownMenuItem<String?>> get partnerDropdownMenuEntries {
    List<DropdownMenuItem<String?>> list = _shared.partners
        .map(
          (e) => DropdownMenuItem<String?>(
            value: e.id,
            child: Text(e.name),
          ),
        )
        .toList();
    list.insert(
      0,
      DropdownMenuItem(
        value: null,
        child: Text(AppLocalizations.of(context)!.unknownPartner),
      ),
    );
    return list;
  }

  List<DropdownMenuItem<Contraceptive?>> get birthControlDropdownMenuEntries {
    List<DropdownMenuItem<Contraceptive?>> list = Contraceptive.values
        .map(
          (e) => DropdownMenuItem<Contraceptive?>(
            value: e,
            child: Text(SharedService.getContraceptiveTranslation(e)),
          ),
        )
        .toList();
    list.insert(
      0,
      DropdownMenuItem(
        value: null,
        child: Text(AppLocalizations.of(context)!.noBirthControl),
      ),
    );
    return list;
  }

  List<DropdownMenuItem<Place?>> get placeDropdownMenuEntries {
    List<DropdownMenuItem<Place?>> list = Place.values
        .map(
          (e) => DropdownMenuItem<Place?>(
            value: e,
            child: Text(SharedService.getPlaceTranslation(e)),
          ),
        )
        .toList();
    list.insert(
      0,
      DropdownMenuItem(
        value: null,
        child: Text(AppLocalizations.of(context)!.unknownPlace),
      ),
    );
    return list;
  }

  List<DropdownMenuItem<Initiator?>> get initiatorDropdownMenuEntries {
    List<DropdownMenuItem<Initiator?>> list = Initiator.values
        .map(
          (e) => DropdownMenuItem<Initiator?>(
            value: e,
            child: Text(SharedService.getInitiatorTranslation(e)),
          ),
        )
        .toList();
    list.insert(
      0,
      DropdownMenuItem(
        value: null,
        child: Text(AppLocalizations.of(context)!.noInitiator),
      ),
    );
    return list;
  }

  void save() {
    if (valid) {
      Activity activity = Activity(
        id: _new ? const Uuid().v4() : widget.activity.id,
        birthControl: _birthControl,
        date: _date ?? DateTime.now(),
        duration: int.parse(_durationController.value.text),
        initiator: _initiator,
        location: _locationController.value.text,
        orgasms: int.parse(_orgasmsController.value.text),
        partner: _partner,
        partnerBirthControl: _partnerBirthControl,
        partnerOrgasms: int.parse(_partnerOrgasmsController.value.text),
        place: _place,
        practices: _practices,
        rating: int.parse(_ratingController.value.text),
        notes: _notesController.value.text,
        type: _type,
        mood: _mood,
      );
      if (!_shared.isLoggedIn) {
        List<Activity> journal = [..._shared.activity];
        if (!_new) {
          Activity? element = journal.firstWhere((e) => e.id == activity.id);
          int index = journal.indexOf(element);
          journal[index] = activity;
        } else {
          journal.add(activity);
        }
        journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
        if (mounted) {
          setState(() => _shared.activity = journal);
        }
        Navigator.pop(context);
      } else {
        try {
          Future request =
              _new ? _api.postActivity(activity) : _api.patchActivity(activity);
          request.then((value) {
            _api.getActivity().then((value) {
              if (mounted) {
                setState(() => _shared.activity = value);
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

  void togglePractice(Practice practice, bool value) {
    setState(() {
      if (value) {
        _practices.add(practice);
      } else {
        _practices.remove(practice);
      }
    });
  }

  bool isPracticeSelected(Practice practice) {
    return _practices.contains(practice);
  }

  void selectMood(Mood? mood, bool value) {
    setState(() {
      _mood = mood;
    });
  }

  bool isMoodSelected(Mood? mood) {
    return _mood == mood;
  }

  List<Widget> get fields {
    List<Widget> fields = [
      ListTile(
        title: Text(AppLocalizations.of(context)!.date),
        leading: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.secondary,
        ),
        trailing:
            _date != null ? Text(DateFormat.yMMMEd().format(_date!)) : null,
        onTap: () => _selectDate(context),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.time),
        leading: Icon(
          Icons.access_time,
          color: Theme.of(context).colorScheme.secondary,
        ),
        trailing: _date != null ? Text(DateFormat.Hm().format(_date!)) : null,
        onTap: () => _selectTime(context),
      ),
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.masturbation),
        secondary: Icon(
          Icons.back_hand,
          color: Theme.of(context).colorScheme.secondary,
        ),
        value: _type == ActivityType.masturbation,
        onChanged: (value) {
          setState(() {
            if (value) {
              _type = ActivityType.masturbation;
            } else {
              _type = ActivityType.sexualIntercourse;
            }
          });
        },
      ),
    ];

    if (_type == ActivityType.sexualIntercourse) {
      fields.addAll(
        [
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _partner,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.partner,
                    ),
                    items: partnerDropdownMenuEntries,
                    onChanged: (value) {
                      setState(() {
                        _partner = value;
                      });
                    },
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
                    value: _birthControl,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.birthControl,
                    ),
                    items: birthControlDropdownMenuEntries,
                    onChanged: (value) {
                      setState(() {
                        _birthControl = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            leading: Icon(
              Icons.medication,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _partnerBirthControl,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context)!.partnerBirthControl,
                    ),
                    items: birthControlDropdownMenuEntries,
                    onChanged: (value) {
                      setState(() {
                        _partnerBirthControl = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            leading: Icon(
              Icons.medication,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      );
    }

    if (!_moreFields) {
      fields.add(
        TextButton(
          onPressed: () => setState(() => _moreFields = !_moreFields),
          child: Text(_moreFields
              ? AppLocalizations.of(context)!.lessFields
              : AppLocalizations.of(context)!.moreFields),
        ),
      );
    }

    if (_moreFields) {
      if (_type == ActivityType.sexualIntercourse) {
        fields.addAll(
          [
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _initiator,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.initiator,
                      ),
                      items: initiatorDropdownMenuEntries,
                      onChanged: (value) {
                        setState(() {
                          _initiator = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              leading: Icon(
                Icons.start,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      }

      fields.addAll([
        ListTile(
          title: Text(AppLocalizations.of(context)!.rating),
          leading: Icon(
            Icons.star_half,
            color: Theme.of(context).colorScheme.secondary,
          ),
          trailing: RatingSelect(
            rating: int.parse(_ratingController.value.text),
            onRatingUpdate: (value) => setState(
              () => _ratingController.value = TextEditingValue(
                text: value.toString(),
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.mood),
          leading: Icon(
            Icons.tag_faces,
            color: Theme.of(context).colorScheme.secondary,
          ),
          subtitle: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...[...Mood.values, null]
                  .map(
                    (e) => FilterChip(
                      label: Text(SharedService.getMoodTranslation(e)),
                      avatar: Text(
                        SharedService.getMoodEmoji(e),
                      ),
                      selected: isMoodSelected(e),
                      onSelected: (value) => selectMood(e, value),
                      showCheckmark: false,
                    ),
                  )
                  .toList()
            ],
          ),
          titleAlignment: ListTileTitleAlignment.top,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.practices),
          leading: Icon(
            Icons.task_alt,
            color: Theme.of(context).colorScheme.secondary,
          ),
          subtitle: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...Practice.values
                  .map(
                    (e) => FilterChip(
                      label: Text(SharedService.getPracticeTranslation(e)),
                      selected: isPracticeSelected(e),
                      onSelected: (value) => togglePractice(e, value),
                      showCheckmark: false,
                    ),
                  )
                  .toList()
            ],
          ),
          titleAlignment: ListTileTitleAlignment.top,
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.duration,
                  ),
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.timer,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _orgasmsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.orgasms,
                  ),
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _partnerOrgasmsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.partnerOrgasms,
                  ),
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  value: _place,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.place,
                  ),
                  items: placeDropdownMenuEntries,
                  onChanged: (value) {
                    setState(() {
                      _place = value;
                    });
                  },
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.place,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.location,
                  ),
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.map,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _notesController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
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
      ]);
    }

    return fields;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null) {
      DateTime pickedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _date!.hour,
        _date!.minute,
      );
      if (pickedDate != _date) {
        setState(() {
          _date = pickedDate;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      initialTime: TimeOfDay.fromDateTime(_date!),
    );
    if (picked != null) {
      DateTime pickedDate = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        picked.hour,
        picked.minute,
      );
      if (pickedDate != _date) {
        setState(() {
          _date = pickedDate;
        });
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
            title: Text(widget.activity.id!.isEmpty
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
          SliverList.builder(
            itemBuilder: (context, index) => fields[index],
            itemCount: fields.length,
          ),
        ],
      ),
    );
  }
}
