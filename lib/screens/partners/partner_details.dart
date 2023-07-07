import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/activity_block.dart';
import 'package:lovelust/widgets/notes_block.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();

  void editPartner() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return PartnerEditPage(partner: widget.partner);
          }),
    );
  }

  Color get headerForegroundColor {
    return Theme.of(context).colorScheme.inverseSurface;
  }

  Color get headerBackgroundColor {
    if (!_common.monochrome) {
      if (widget.partner.sex == 'M') {
        return Colors.blue
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(_common.alpha);
      } else {
        return Colors.red
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(_common.alpha);
      }
    } else {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
  }

  Icon get genderIcon {
    IconData icon = Icons.transgender;
    Color color = Theme.of(context).colorScheme.primary;
    if (widget.partner.gender == 'F') {
      icon = Icons.female;
    } else if (widget.partner.gender == 'M') {
      icon = Icons.male;
    }
    if (!_common.monochrome) {
      if (widget.partner.sex == 'F') {
        color = Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
      } else if (widget.partner.sex == 'M') {
        color =
            Colors.blue.harmonizeWith(Theme.of(context).colorScheme.primary);
      }
    }
    return Icon(icon, color: color);
  }

  Widget get encounters {
    Color color = Theme.of(context).colorScheme.onSurface;
    if (!_common.monochrome) {
      color = Colors.pink.harmonizeWith(Theme.of(context).colorScheme.primary);
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _common
                .getActivityByPartner(widget.partner.id)
                .length
                .toString(),
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
    debugPrint(item.name);
    if (item.name == 'delete') {
      if (_common.isLoggedIn) {
        _api.deletePartner(widget.partner).then(
              (value) => Navigator.pop(context),
            );
      } else {
        List<Partner> partners = [..._common.partners];
        partners.removeWhere((element) => element.id == widget.partner.id);
        setState(() {
          _common.partners = partners;
        });
        Navigator.pop(context);
      }
    }
  }

  get cards {
    List<Widget> list = [];
    if (widget.partner.notes != null) {
      list.add(
        NotesBlock(
          notes: widget.partner.notes!,
        ),
      );
    }
    List<Widget> activity = _common
        .getActivityByPartner(widget.partner.id)
        .map((e) => ActivityBlock(activity: e))
        .toList();
    list = [...list, ...activity];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar.large(
              floating: false,
              pinned: true,
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: widget.partner.name),
                    WidgetSpan(child: genderIcon),
                  ],
                ),
              ),
              backgroundColor: headerBackgroundColor,
              actions: [
                IconButton(
                    onPressed: editPartner, icon: const Icon(Icons.edit)),
                PopupMenuButton(
                  onSelected: menuEntryItemSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuEntryItem>>[
                    const PopupMenuItem(
                      value: MenuEntryItem.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cards,
        ),
      ),
    );
  }
}
