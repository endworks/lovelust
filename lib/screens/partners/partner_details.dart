import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();
  int alpha = Colors.black26.alpha;

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
    if (widget.partner.sex == 'M') {
      return Colors.blue.withAlpha(alpha);
    } else {
      return Colors.red.withAlpha(alpha);
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
    if (widget.partner.sex == 'F') {
      color = Colors.red;
    } else if (widget.partner.sex == 'M') {
      color = Colors.blue;
    }
    return Icon(icon, color: color);
  }

  Widget get encounters {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.favorite, color: Colors.red),
        Text(
          _common.getActivityByPartner(widget.partner.id).length.toString(),
          style: const TextStyle(
            color: Colors.red,
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 128,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 72,
                  bottom: 16,
                  end: 88,
                ),
                background: DecoratedBox(
                  decoration: BoxDecoration(color: headerBackgroundColor),
                ),
                title: Row(children: [
                  Text(
                    widget.partner.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: headerForegroundColor,
                    ),
                  ),
                  genderIcon,
                ]),
              ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.partner.notes ?? '',
            )
          ],
        ),
      ),
    );
  }
}
