import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/screens/settings/login_dialog.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/generic_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SharedService _common = getIt<SharedService>();

  reload() {
    Phoenix.rebirth(context);
  }

  changeTheme(String? value) {
    if (_common.theme != value) {
      setState(() {
        _common.theme = value ?? 'system';
      });
      reload();
    }
  }

  changeColorScheme(String? value) {
    if (_common.colorScheme != value) {
      setState(() {
        _common.colorScheme = value;
      });
      reload();
    }
  }

  List<DropdownMenuItem<String>> get dropdownColorSchemeItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "default",
          child: Text(AppLocalizations.of(context)!.defaultColorScheme)),
      DropdownMenuItem(
          value: "dynamic",
          child: Text(AppLocalizations.of(context)!.dynamicColorScheme)),
      DropdownMenuItem(
          value: "experimental",
          child: Text(AppLocalizations.of(context)!.experimental)),
      DropdownMenuItem(
          value: "lovelust",
          child: Text(AppLocalizations.of(context)!.lovelust)),
      DropdownMenuItem(
          value: "love", child: Text(AppLocalizations.of(context)!.love)),
      DropdownMenuItem(
          value: "lust", child: Text(AppLocalizations.of(context)!.lust)),
      DropdownMenuItem(
          value: "lustfullove",
          child: Text(AppLocalizations.of(context)!.lustfullove)),
      DropdownMenuItem(
          value: "lovefullust",
          child: Text(AppLocalizations.of(context)!.lovefullust)),
      DropdownMenuItem(
          value: "redlight",
          child: Text(AppLocalizations.of(context)!.redlight)),
      DropdownMenuItem(
          value: "monochrome",
          child: Text(AppLocalizations.of(context)!.monochrome)),
    ];
    return menuItems;
  }

  Widget get colorSchemeName {
    DropdownMenuItem value = dropdownColorSchemeItems.firstWhere((element) =>
        element.value == _common.colorScheme ||
        (element.value == "default" && _common.colorScheme == null));
    return Text(
      (value.child as Text).data!,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownThemeItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "system", child: Text(AppLocalizations.of(context)!.system)),
      DropdownMenuItem(
          value: "light", child: Text(AppLocalizations.of(context)!.light)),
      DropdownMenuItem(
          value: "dark", child: Text(AppLocalizations.of(context)!.dark)),
    ];
    return menuItems;
  }

  Widget get themeName {
    DropdownMenuItem value = dropdownThemeItems
        .firstWhere((element) => element.value == _common.theme);
    return Text(
      (value.child as Text).data!,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownAppIconItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: null,
        child: Text(AppLocalizations.of(context)!.defaultAppIcon),
      ),
      DropdownMenuItem(
        value: "Beta",
        child: Text(AppLocalizations.of(context)!.beta),
      ),
      DropdownMenuItem(
        value: "White",
        child: Text(AppLocalizations.of(context)!.white),
      ),
      DropdownMenuItem(
        value: "Pride",
        child: Text(AppLocalizations.of(context)!.pride),
      ),
      DropdownMenuItem(
        value: "PrideAlt",
        child: Text(AppLocalizations.of(context)!.prideAlt),
      ),
    ];
    return menuItems;
  }

  Widget get appIconName {
    DropdownMenuItem value = dropdownAppIconItems
        .firstWhere((element) => element.value == _common.currentIconName);
    return Text(
      (value.child as Text).data!,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
    );
  }

  Future<void> _askTheme() async {
    String? value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.appearance),
          children: dropdownThemeItems
              .map(
                (e) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, e.value);
                  },
                  child: e.child,
                ),
              )
              .toList(),
        );
      },
    );

    if (value != null && _common.theme != value) {
      setState(() {
        _common.theme = value;
      });
      reload();
    }
  }

  Future<bool?> _askConfirmation(String title, String description) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _askClearPersonalData() async {
    bool? result = await _askConfirmation(
      AppLocalizations.of(context)!.confirmClearDataTitle,
      AppLocalizations.of(context)!.confirmClearDataDescription,
    );
    if (result != null && result) {
      _common.clearPersonalData();
      reload();
    }
  }

  Future<void> _askClearData() async {
    bool? result = await _askConfirmation(
      AppLocalizations.of(context)!.confirmClearDataTitle,
      AppLocalizations.of(context)!.confirmClearDataDescription,
    );
    if (result != null && result) {
      _common.clearData();
      reload();
    }
  }

  Future<void> _askColorScheme() async {
    String? value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.colorScheme),
          children: dropdownColorSchemeItems
              .map(
                (e) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, e.value);
                  },
                  child: e.child,
                ),
              )
              .toList(),
        );
      },
    );

    if (value != null && _common.colorScheme != value) {
      setState(() {
        _common.colorScheme = value != 'default' ? value : null;
      });
      reload();
    }
  }

  Future<void> _askAppIcon() async {
    String? value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.appIcon),
          children: dropdownAppIconItems
              .map(
                (e) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, e.value);
                  },
                  child: e.child,
                ),
              )
              .toList(),
        );
      },
    );

    if (value != null && _common.currentIconName != value) {
      setState(() {
        _common.currentIconName = value;
      });
      try {
        if (await FlutterDynamicIcon.supportsAlternateIcons) {
          await FlutterDynamicIcon.setAlternateIconName(value);
        }
      } on PlatformException {
        debugPrint("Platform interaction failed");
      } catch (e) {
        debugPrint("Failed to change app icon");
      }
    }
  }

  _handleLogin() {
    if (_common.isLoggedIn) {
      _common.signOut();
      reload();
    } else {
      showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return const SizedBox(
            height: 300,
            child: LoginDialog(),
          );
        },
      );
    }
  }

  _changeIcon() {
    try {
      FlutterDynamicIcon.supportsAlternateIcons.then((value) {
        if (value) {
          FlutterDynamicIcon.setAlternateIconName("teamfortress",
                  showAlert: true)
              .then((value) => null);
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("App icon change successful"),
          ),
        );
        FlutterDynamicIcon.getAlternateIconName().then((v) {
          setState(() {
            _common.currentIconName = v ?? "`primary`";
          });
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to change app icon"),
        ),
      );
    }
  }

  String? get installerStore {
    if (_common.packageInfo?.installerStore == 'com.apple.simulator') {
      return 'Simulator';
    } else if (_common.packageInfo?.installerStore == 'com.apple.testflight') {
      return 'TestFlight';
    } else if (_common.packageInfo?.installerStore == 'com.apple.appstore') {
      return 'AppStore';
    } else if (_common.packageInfo?.installerStore == 'com.android.vending') {
      return 'Play Store';
    }
    return _common.packageInfo?.installerStore;
  }

  List<Widget> get items {
    List<Widget> list = [
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.requireAuth),
        subtitle: Text(
          AppLocalizations.of(context)!.requireAuthDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _common.requireAuth,
        onChanged: (bool value) {
          setState(() {
            _common.requireAuth = value;
          });
        },
        secondary: Icon(
          Icons.fingerprint,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.privacyMode),
        subtitle: Text(
          AppLocalizations.of(context)!.privacyModeDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _common.privacyMode,
        onChanged: (bool value) {
          setState(() {
            _common.privacyMode = value;
          });
        },
        secondary: Icon(
          Icons.visibility_off,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.appearance),
        subtitle: themeName,
        onTap: _askTheme,
        leading: Icon(
          Icons.dark_mode,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.colorScheme),
        subtitle: colorSchemeName,
        onTap: _askColorScheme,
        leading: Icon(
          Icons.color_lens,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearPersonalData),
        subtitle: Text(
          AppLocalizations.of(context)!.clearPersonalDataDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        onTap: _askClearPersonalData,
        leading: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearData),
        subtitle: Text(
          AppLocalizations.of(context)!.clearDataDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        onTap: _askClearData,
        leading: Icon(
          Icons.delete_forever,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.version),
        subtitle: Text(
          "${_common.packageInfo?.version ?? '1.0.0'} (${_common.packageInfo?.buildNumber ?? 1}) ${installerStore ?? 'store'}",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        leading: Icon(
          Icons.app_settings_alt,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ];
    if (_common.isLoggedIn) {
      list.insert(
        list.length - 1,
        ListTile(
          title: Text(AppLocalizations.of(context)!.initialFetch),
          subtitle: Text(
            AppLocalizations.of(context)!.initialFetchDescription,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          leading: Icon(
            Icons.download,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: _common.initialFetch,
        ),
      );
    }

    if (!kIsWeb && Platform.isIOS) {
      list.insert(
        4,
        ListTile(
          title: Text(AppLocalizations.of(context)!.appIcon),
          subtitle: appIconName,
          onTap: _askAppIcon,
          leading: Icon(
            Icons.app_shortcut,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          GenericHeader(
            title: Text(AppLocalizations.of(context)!.settings),
            actions: [
              IconButton(
                onPressed: _handleLogin,
                icon: Icon(_common.isLoggedIn ? Icons.logout : Icons.login),
              )
            ],
          ),
          SliverList.list(
            children: items,
          )
        ],
      ),
    );
  }
}
