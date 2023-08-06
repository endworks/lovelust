import 'dart:io';

import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/generic_header.dart';

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
        setState(() {
          _shared.appIcon = selectedAppIcon;
        });
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
        value: "Pink",
        child: Text(AppLocalizations.of(context)!.love),
      ),
      DropdownMenuItem(
        value: "Purple",
        child: Text(AppLocalizations.of(context)!.lust),
      ),
      DropdownMenuItem(
        value: "Red",
        child: Text(AppLocalizations.of(context)!.lipstick),
      ),
      DropdownMenuItem(
        value: "Blue",
        child: Text(AppLocalizations.of(context)!.blue),
      ),
      DropdownMenuItem(
        value: "Teal",
        child: Text(AppLocalizations.of(context)!.shimapan),
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
        value: "Glow",
        child: Text(AppLocalizations.of(context)!.glow),
      ),
      DropdownMenuItem(
        value: "Neon",
        child: Text(AppLocalizations.of(context)!.neon),
      ),
      DropdownMenuItem(
        value: "Pride",
        child: Text(AppLocalizations.of(context)!.pride),
      ),
      DropdownMenuItem(
        value: "PrideRainbow",
        child: Text(AppLocalizations.of(context)!.prideRainbow),
      ),
      DropdownMenuItem(
        value: "PrideClassic",
        child: Text(AppLocalizations.of(context)!.prideClassic),
      ),
      DropdownMenuItem(
        value: "PrideBi",
        child: Text(AppLocalizations.of(context)!.prideBi),
      ),
      DropdownMenuItem(
        value: "PrideTrans",
        child: Text(AppLocalizations.of(context)!.prideTrans),
      ),
      DropdownMenuItem(
        value: "PrideAce",
        child: Text(AppLocalizations.of(context)!.prideAce),
      ),
      DropdownMenuItem(
        value: "AltWhite",
        child: Text(AppLocalizations.of(context)!.altWhite),
      ),
      DropdownMenuItem(
        value: "AltBlack",
        child: Text(AppLocalizations.of(context)!.altBlack),
      ),
      DropdownMenuItem(
        value: "Health",
        child: Text(AppLocalizations.of(context)!.health),
      ),
      DropdownMenuItem(
        value: "Health2",
        child: Text(AppLocalizations.of(context)!.health2),
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
            leading: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(64, 128, 128, 128),
                  ),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    image: AssetImage("assets/AppIcons/${e.value}.png"),
                  ),
                ),
              ),
            ),
            trailing: Radio<String>(
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
          GenericHeader(
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
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).padding.left,
              0,
              MediaQuery.of(context).padding.right,
              MediaQuery.of(context).padding.bottom,
            ),
            sliver: SliverList.builder(
              itemBuilder: (context, index) => fields[index],
              itemCount: fields.length,
            ),
          ),
        ],
      ),
    );
  }
}
