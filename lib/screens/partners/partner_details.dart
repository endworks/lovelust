import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/blocks/activity_block.dart';
import 'package:lovelust/widgets/blocks/date_block.dart';
import 'package:lovelust/widgets/blocks/notes_block.dart';
import 'package:lovelust/widgets/blocks/socials_block.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/partner_avatar.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  final SharedService _shared = getIt<SharedService>();
  late Partner _partner;

  @override
  void initState() {
    super.initState();
    _partner = widget.partner;
    _shared.addListener(() {
      if (mounted) {
        setState(() {
          _partner = _shared.getPartnerById(_partner.id!)!;
        });
      }
    });
  }

  void editPartner() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        fullscreenDialog: true,
        settings: const RouteSettings(name: 'PartnerEdit'),
        builder: (BuildContext context) => PartnerEditPage(partner: _partner),
      ),
    );
  }

  Icon get genderIcon {
    IconData icon = Icons.transgender;
    Color color = Theme.of(context).colorScheme.primary;
    if (_partner.gender == Gender.female) {
      icon = Icons.female;
    } else if (_partner.gender == Gender.male) {
      icon = Icons.male;
    }

    if (_partner.sex == BiologicalSex.female) {
      color = Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
    } else if (_partner.sex == BiologicalSex.male) {
      color = Colors.blue.harmonizeWith(Theme.of(context).colorScheme.primary);
    }

    return Icon(icon, color: color);
  }

  Widget get encounters {
    Color color =
        Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _shared.getActivityByPartner(_partner.id!).length.toString(),
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          WidgetSpan(
            child: Icon(Icons.favorite, color: color),
          ),
        ],
      ),
    );
  }

  void menuEntryItemSelected(MenuEntryItem item) {
    if (item.name == 'delete') {
      askConfirmDelete();
    }
  }

  Future<void> askConfirmDelete() async {
    bool? result = await _shared.askConfirmation(
      AppLocalizations.of(context)!.confirmDeletePartnerTitle,
      AppLocalizations.of(context)!.confirmDeletePartnerDescription,
    );
    if (result != null && result) {
      HapticFeedback.selectionClick();
      List<Partner> partners = [..._shared.partners];
      partners.removeWhere((element) => element.id == _partner.id);
      setState(() {
        _shared.partners = partners;
      });
      Navigator.pop(context);
    }
  }

  get cards {
    List<Widget> list = [
      PartnerAvatar(partner: _partner),
    ];
    if (_partner.phone != null ||
        _partner.instagram != null ||
        _partner.x != null ||
        _partner.snapchat != null ||
        _partner.onlyfans != null) {
      list.add(
        SocialsBlock(
          phone: _partner.phone,
          instagram: _partner.instagram,
          x: _partner.x,
          snapchat: _partner.snapchat,
          onlyfans: _partner.onlyfans,
        ),
      );
    }
    if (_partner.birthDay != null) {
      list.add(
        DateBlock(
          date: _partner.birthDay!,
          label: AppLocalizations.of(context)!.birthDay,
        ),
      );
    }
    if (_partner.notes != null && _partner.notes!.isNotEmpty) {
      list.add(
        NotesBlock(
          notes: _partner.notes!,
        ),
      );
    }
    List<Widget> activity = _shared
        .getActivityByPartner(_partner.id!)
        .map((e) => ActivityBlock(activity: e))
        .toList();
    list = [...list, ...activity];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          GenericHeader(
            actions: [
              IconButton(onPressed: editPartner, icon: const Icon(Icons.edit)),
              PopupMenuButton(
                onSelected: menuEntryItemSelected,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuEntryItem>>[
                  PopupMenuItem(
                    value: MenuEntryItem.delete,
                    child: Text(AppLocalizations.of(context)!.delete),
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
            sliver: SliverList.list(
              children: cards,
            ),
          ),
        ],
      ),
    );
  }
}
