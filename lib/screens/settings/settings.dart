import 'dart:io';

import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lovelust/screens/settings/login_dialog.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/generic_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SharedService _shared = getIt<SharedService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  bool isiOSAppOnMac = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isIOS) {
      checkIfiOSAppOnMac();
    }
  }

  reload() {
    Phoenix.rebirth(context);
  }

  Future<void> checkIfiOSAppOnMac() async {
    const platform = MethodChannel('works.end.Lovelust/isiOSAppOnMac');
    try {
      isiOSAppOnMac = await platform.invokeMethod('isiOSAppOnMacChannel');
    } on PlatformException {
      isiOSAppOnMac = false;
    }
    setState(() => isiOSAppOnMac = isiOSAppOnMac);
  }

  changeTheme(String? value) {
    if (_shared.theme != value) {
      setState(() {
        _shared.theme = value ?? 'system';
      });
      reload();
    }
  }

  changeColorScheme(String? value) {
    if (_shared.colorScheme != value) {
      setState(() {
        _shared.colorScheme = value;
      });
      reload();
    }
  }

  String get authMethodName {
    if (_localAuth.availableBiometrics?[0] == BiometricType.face) {
      if (Platform.isIOS) {
        return AppLocalizations.of(context)!.requireFaceID;
      } else {
        return AppLocalizations.of(context)!.requireFace;
      }
    } else if (_localAuth.availableBiometrics?[0] ==
        BiometricType.fingerprint) {
      if (Platform.isIOS) {
        return AppLocalizations.of(context)!.requireTouchID;
      } else {
        return AppLocalizations.of(context)!.requireFingerprint;
      }
    }
    return AppLocalizations.of(context)!.requireAuth;
  }

  String get authMethodDescription {
    if (_localAuth.availableBiometrics?[0] == BiometricType.face) {
      if (Platform.isIOS) {
        return AppLocalizations.of(context)!.requireFaceIDDescription;
      } else {
        return AppLocalizations.of(context)!.requireFaceDescription;
      }
    } else if (_localAuth.availableBiometrics?[0] ==
        BiometricType.fingerprint) {
      if (Platform.isIOS) {
        return AppLocalizations.of(context)!.requireTouchIDDescription;
      } else {
        return AppLocalizations.of(context)!.requireFingerprintDescription;
      }
    }
    return AppLocalizations.of(context)!.requireAuthDescription;
  }

  IconData get authMethodIcon {
    if (_localAuth.availableBiometrics?[0] == BiometricType.face) {
      return Icons.face;
    }
    return Icons.fingerprint;
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
          value: "lust", child: Text(AppLocalizations.of(context)!.lust)),
      DropdownMenuItem(
          value: "love", child: Text(AppLocalizations.of(context)!.love)),
      /*DropdownMenuItem(
          value: "lovelust",
          child: Text(AppLocalizations.of(context)!.lovelust)),*/
      DropdownMenuItem(
          value: "lipstick",
          child: Text(AppLocalizations.of(context)!.lipstick)),
      /*DropdownMenuItem(
          value: "lustfullove",
          child: Text(AppLocalizations.of(context)!.lustfullove)),
      DropdownMenuItem(
          value: "lovefullust",
          child: Text(AppLocalizations.of(context)!.lovefullust)),*/
      DropdownMenuItem(
          value: "monochrome",
          child: Text(AppLocalizations.of(context)!.monochrome)),
      DropdownMenuItem(
          value: "experimental",
          child: Text(AppLocalizations.of(context)!.experimental)),
    ];
    return menuItems;
  }

  Widget get colorSchemeName {
    DropdownMenuItem value = dropdownColorSchemeItems.firstWhere((element) =>
        element.value == _shared.colorScheme ||
        (element.value == "default" && _shared.colorScheme == null));
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
          value: "light", child: Text(AppLocalizations.of(context)!.light)),
      DropdownMenuItem(
          value: "dark", child: Text(AppLocalizations.of(context)!.dark)),
      DropdownMenuItem(
          value: "system", child: Text(AppLocalizations.of(context)!.system)),
    ];
    return menuItems;
  }

  Widget get themeName {
    DropdownMenuItem value = dropdownThemeItems
        .firstWhere((element) => element.value == _shared.theme);
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

  Widget get appIconName {
    DropdownMenuItem value = dropdownAppIconItems
        .firstWhere((element) => element.value == _shared.appIcon);
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
          title: Text(AppLocalizations.of(context)!.chooseTheme),
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

    if (value != null && _shared.theme != value) {
      setState(() {
        _shared.theme = value;
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
      _shared.clearPersonalData();
      reload();
    }
  }

  Future<void> _askClearData() async {
    bool? result = await _askConfirmation(
      AppLocalizations.of(context)!.confirmClearDataTitle,
      AppLocalizations.of(context)!.confirmClearDataDescription,
    );
    if (result != null && result) {
      _shared.clearData();
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

    if (value != null && _shared.colorScheme != value) {
      if (value == 'default' && _shared.colorScheme == null) {
        return;
      }
      setState(() {
        _shared.colorScheme = value != 'default' ? value : null;
      });
      reload();
    }
  }

  Future<void> _askAppIcon() {
    return showDialog<String>(
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
    ).then((String? value) {
      if (value != null && _shared.appIcon != value) {
        try {
          if (Platform.isIOS) {
            setState(() {
              _shared.appIcon = value;
            });
            DynamicIconFlutter.supportsAlternateIcons.then((supported) {
              DynamicIconFlutter.setAlternateIconName(value)
                  .then((value) => null);
            });
          } else if (Platform.isAndroid) {
            List<String> list = dropdownAppIconItems
                .map<String>(
                    (DropdownMenuItem<String> e) => e.value ?? 'Default')
                .toList();
            DynamicIconFlutter.setIcon(icon: value, listAvailableIcon: list);
          }
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
    });
  }

  _handleLogin() {
    if (_shared.isLoggedIn) {
      _shared.signOut();
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

  String? get installerStore {
    if (_shared.packageInfo?.installerStore == 'com.apple.simulator') {
      return 'Simulator';
    } else if (_shared.packageInfo?.installerStore == 'com.apple.testflight') {
      return 'TestFlight';
    } else if (_shared.packageInfo?.installerStore == 'com.apple.appstore') {
      return 'AppStore';
    } else if (_shared.packageInfo?.installerStore == 'com.android.vending') {
      return 'Play Store';
    }
    return _shared.packageInfo?.installerStore;
  }

  void toggleRequireAuth(bool value) {
    _localAuth.authenticate().then(
      (_) {
        if (_localAuth.authorized) {
          setState(() {
            _shared.requireAuth = value;
          });
        }
      },
    );
  }

  List<Widget> get items {
    List<Widget> list = [
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.privacyMode),
        subtitle: Text(
          AppLocalizations.of(context)!.privacyModeDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _shared.privacyMode,
        onChanged: (bool value) {
          setState(() {
            _shared.privacyMode = value;
          });
        },
        secondary: Icon(
          Icons.visibility_off,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.theme),
        subtitle: themeName,
        onTap: _askTheme,
        leading: Icon(
          Icons.brightness_4,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.colorScheme),
        subtitle: colorSchemeName,
        onTap: _askColorScheme,
        leading: Icon(
          Icons.palette,
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
          "${_shared.packageInfo?.version ?? '1.0.0'} (${_shared.packageInfo?.buildNumber ?? 1}) ${installerStore ?? 'store'}",
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

    if (_localAuth.availableBiometrics != null) {
      list.insert(
        0,
        SwitchListTile(
          title: Text(authMethodName),
          subtitle: Text(
            authMethodDescription,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          value: _shared.requireAuth,
          onChanged: (bool value) {
            toggleRequireAuth(value);
          },
          secondary: Icon(
            authMethodIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    if (_shared.isLoggedIn) {
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
          onTap: _shared.initialFetch,
        ),
      );
    }

    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid) && !isiOSAppOnMac) {
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
                icon: Icon(_shared.isLoggedIn ? Icons.logout : Icons.login),
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
