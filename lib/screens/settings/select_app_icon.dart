import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:lovelust/l10n/app_localizations.dart';
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
  late AppIcon? selectedAppIcon;

  @override
  void initState() {
    super.initState();
    selectedAppIcon = _shared.appIcon;
  }

  void save() {
    if (_shared.appIcon != selectedAppIcon) {
      try {
        if (Platform.isIOS) {
          FlutterDynamicIconPlus.supportsAlternateIcons.then(
            (supported) {
              String? appIcon =
                  SharedService.setValueByAppIcon(selectedAppIcon);
              FlutterDynamicIconPlus.setAlternateIconName(iconName: appIcon)
                  .then(
                (value) => null,
              );
            },
          );
        } else if (Platform.isAndroid) {
          FlutterDynamicIconPlus.setAlternateIconName(
            iconName:
                SharedService.setValueByAppIcon(selectedAppIcon) ?? 'Default',
          );
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

  void onChanged(AppIcon? value) {
    setState(() {
      selectedAppIcon = value!;
    });
  }

  List<DropdownMenuItem<AppIcon?>> get dropdownAppIconItems {
    List<DropdownMenuItem<AppIcon?>> list = AppIcon.values
        .map(
          (e) => DropdownMenuItem<AppIcon?>(
            value: e,
            child: Text(SharedService.getAppIconTranslation(e)),
          ),
        )
        .toList();
    return list;
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
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(32, 128, 128, 128),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    image: AssetImage(
                        "assets/AppIcons/${SharedService.setValueByAppIcon(e.value) ?? 'Default'}.png"),
                  ),
                ),
              ),
            ),
            trailing: Radio<AppIcon?>(
              value: e.value,
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
