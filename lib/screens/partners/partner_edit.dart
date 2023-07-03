import 'package:flutter/material.dart';
import 'package:lovelust/forms/partner_form.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';

class PartnerEditPage extends StatefulWidget {
  const PartnerEditPage({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerEditPage> createState() => _PartnerEditPageState();
}

class _PartnerEditPageState extends State<PartnerEditPage> {
  void save() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit partner'),
        actions: [
          FilledButton(onPressed: save, child: const Text('Save')),
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
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: PartnerForm(partner: widget.partner),
    );
  }
}
