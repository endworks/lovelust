import 'dart:io';

import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class SelectAppIconPage extends StatefulWidget {
  const SelectAppIconPage({super.key});

  @override
  State<SelectAppIconPage> createState() => _SelectAppIconPageState();
}

class _SelectAppIconPageState extends State<SelectAppIconPage> {
  final SharedService _shared = getIt<SharedService>();
  late String selectedAppIcon;

  @override
  void initState() {
    super.initState();
    selectedAppIcon = _shared.appIcon;
  }

  void save() {
    if (_shared.appIcon != selectedAppIcon) {
      try {
        if (Platform.isIOS) {
          setState(() {
            _shared.appIcon = selectedAppIcon!;
          });
          DynamicIconFlutter.supportsAlternateIcons.then((supported) {
            String? appIcon =
                selectedAppIcon != 'Default' ? selectedAppIcon : null;
            DynamicIconFlutter.setAlternateIconName(appIcon)
                .then((value) => null);
          });
        } else if (Platform.isAndroid) {
          List<String> list = dropdownAppIconItems
              .map<String>((DropdownMenuItem<String> e) => e.value ?? 'Default')
              .toList();
          DynamicIconFlutter.setIcon(
              icon: selectedAppIcon, listAvailableIcon: list);
        }
        Navigator.of(context).pop();
      } on PlatformException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Platform not supported"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to change app icon"),
          ),
        );
      }
    }
  }

  void onChanged(String? value) {
    debugPrint('onChanged: $value');
    setState(() {
      selectedAppIcon = value!;
    });
  }

  List<DropdownMenuItem<String>> get dropdownAppIconItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: "Default",
        child: Text(AppLocalizations.of(context)!.defaultAppIcon),
      ),
      DropdownMenuItem(
        value: "Beta",
        child: Text(AppLocalizations.of(context)!.beta),
      ),
      DropdownMenuItem(
        value: "Neon",
        child: Text(AppLocalizations.of(context)!.neon),
      ),
      DropdownMenuItem(
        value: "Health",
        child: Text(AppLocalizations.of(context)!.health),
      ),
      DropdownMenuItem(
        value: "Pride",
        child: Text(AppLocalizations.of(context)!.pride),
      ),
      DropdownMenuItem(
        value: "PrideAlt",
        child: Text(AppLocalizations.of(context)!.prideAlt),
      ),
      DropdownMenuItem(
        value: "White",
        child: Text(AppLocalizations.of(context)!.white),
      ),
      DropdownMenuItem(
        value: "Black",
        child: Text(AppLocalizations.of(context)!.black),
      ),
      DropdownMenuItem(
        value: "Monochrome",
        child: Text(AppLocalizations.of(context)!.monochrome),
      ),
      DropdownMenuItem(
        value: "Sexapill",
        child: Text(AppLocalizations.of(context)!.sexapill),
      ),
    ];
    return menuItems;
  }

  List<Widget> get fields {
    List<Widget> fields = dropdownAppIconItems
        .map(
          (e) => ListTile(
            title: e.child,
            onTap: () => onChanged(e.value),
            leading: Image(
              image: AssetImage("assets/AppIcons/${e.value}.png"),
            ),
            trailing: Radio<String>.adaptive(
              value: e.value!,
              groupValue: selectedAppIcon,
              onChanged: onChanged,
            ),
          ),
        )
        .toList();
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text(AppLocalizations.of(context)!.appIcon),
            actions: [
              FilledButton(
                onPressed: selectedAppIcon != _shared.appIcon ? save : null,
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
          SliverList.builder(
            itemBuilder: (context, index) => fields[index],
            itemCount: fields.length,
          ),
        ],
      ),
    );
  }
}
