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
        FlutterDynamicIconPlus.supportsAlternateIcons.then(
          (supported) {
            String? appIcon = SharedService.setValueByAppIcon(selectedAppIcon);
            if (Platform.isAndroid && appIcon == null) {
              appIcon = 'Default';
            }
            FlutterDynamicIconPlus.setAlternateIconName(iconName: appIcon).then(
              (value) => null,
            );
            setState(() => _shared.appIcon = selectedAppIcon);
            if (context.mounted) Navigator.of(context).pop();
          },
        );
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
    setState(() => selectedAppIcon = value!);
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

  Widget? iconRenamesApp(AppIcon icon) {
    if (icon == AppIcon.health ||
        icon == AppIcon.health2 ||
        icon == AppIcon.health3 ||
        icon == AppIcon.journal ||
        icon == AppIcon.sexapill ||
        icon == AppIcon.sexapillWhite) {
      return Text(AppLocalizations.of(context)!.renamesApp);
    }
    return null;
  }

  List<Widget> get fields {
    return AppIcon.values
        .map(
          (e) => ListTile(
            title: Text(SharedService.getAppIconTranslation(e)),
            subtitle: iconRenamesApp(e),
            onTap: () => onChanged(e),
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
                        "assets/AppIcons/${SharedService.setValueByAppIcon(e) ?? 'Default'}.png"),
                  ),
                ),
              ),
            ),
            trailing: Radio<AppIcon?>(
              value: e,
              groupValue: selectedAppIcon,
              onChanged: onChanged,
            ),
          ),
        )
        .toList();
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
