import 'package:flutter/material.dart';
import 'package:lovelust/models/model_entry_item.dart';

class PartnerAddPage extends StatefulWidget {
  const PartnerAddPage({super.key});

  @override
  State<PartnerAddPage> createState() => _PartnerAddPageState();
}

class _PartnerAddPageState extends State<PartnerAddPage> {
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
                value: MenuEntryItem.info,
                child: Text('Info'),
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
