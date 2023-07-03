import 'package:flutter/material.dart';
import 'package:lovelust/forms/partner_form.dart';
import 'package:lovelust/models/model_entry_item.dart';
import 'package:lovelust/models/partner.dart';

class PartnerAddPage extends StatefulWidget {
  const PartnerAddPage({super.key});

  @override
  State<PartnerAddPage> createState() => _PartnerAddPageState();
}

class _PartnerAddPageState extends State<PartnerAddPage> {
  Partner partner = Partner(
    id: '',
    sex: 'M',
    gender: 'M',
    name: '',
    meetingDate: DateTime.now(),
    notes: null,
    activity: null,
  );

  void save() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create partner'),
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
      body: PartnerForm(partner: partner),
    );
  }
}
