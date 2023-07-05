import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_edit.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  int fgValue = 500;
  int bgValue = 100;

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
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    int bg = darkMode ? fgValue : bgValue;
    if (widget.partner.gender == 'M') {
      return Colors.blue[bg]!;
    } else {
      return Colors.red[bg]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 128.0,
              floating: false,
              pinned: true,
              backgroundColor: headerBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(
                  widget.partner.name,
                  style: TextStyle(
                    color: headerForegroundColor,
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: editPartner, icon: const Icon(Icons.edit)),
                PopupMenuButton(
                  onSelected: (MenuEntryItem item) {},
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
        body: Center(
          child: Text("Sample Text"),
        ),
      ),
    );
  }
}
