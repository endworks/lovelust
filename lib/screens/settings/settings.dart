import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/settings/health_integration.dart';
import 'package:lovelust/screens/settings/select_app_icon.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/health_service.dart';
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
  final HealthService _health = getIt<HealthService>();
  final ScrollController _scrollController = ScrollController();
  bool isiOSAppOnMac = false;
  bool isHealthIntegrationAvailable = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isIOS) {
      checkIfiOSAppOnMac();
    }

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 0.0;
      });
    });

    _shared.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    FlutterDynamicIconPlus.alternateIconName.then((iconName) {
      setState(() {
        if (iconName.toString().contains('.')) {
          _shared.appIcon = SharedService.getAppIconByValue(
            iconName.toString().split('.').last,
          );
        } else {
          _shared.appIcon = SharedService.getAppIconByValue(iconName);
        }
      });
    });

    _health.isAvailable().then((available) {
      setState(() {
        isHealthIntegrationAvailable = available;
      });
    });
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

  changeColorScheme(AppColorScheme? value) {
    if (_shared.colorScheme != value) {
      setState(() {
        _shared.colorScheme = value;
      });
      reload();
    }
  }

  String get authMethodName {
    if (_localAuth.availableBiometrics != null &&
        _localAuth.availableBiometrics!.isNotEmpty) {
      if (_localAuth.availableBiometrics!.contains(BiometricType.face)) {
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
      } else {
        return AppLocalizations.of(context)!.requireAuth;
      }
    }
    return AppLocalizations.of(context)!.requirePasscode;
  }

  String get authMethodDescription {
    if (_localAuth.availableBiometrics != null &&
        _localAuth.availableBiometrics!.isNotEmpty) {
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
    } else {
      return AppLocalizations.of(context)!.requirePasscodeDescription;
    }
  }

  IconData get authMethodIcon {
    if (_localAuth.availableBiometrics != null &&
        _localAuth.availableBiometrics!.isNotEmpty) {
      if (_localAuth.availableBiometrics?[0] == BiometricType.face) {
        return Icons.face;
      } else if (_localAuth.availableBiometrics?[0] ==
          BiometricType.fingerprint) {
        return Icons.fingerprint;
      }
    } else {
      return Icons.password;
    }
    return Icons.fingerprint;
  }

  List<DropdownMenuItem<AppColorScheme?>> get dropdownColorSchemeItems {
    List<DropdownMenuItem<AppColorScheme?>> menuItems = AppColorScheme.values
        .map(
          (e) => DropdownMenuItem<AppColorScheme?>(
            value: e,
            child: Text(SharedService.getAppColorSchemeTranslation(e)),
          ),
        )
        .toList();
    if (kIsWeb || !Platform.isAndroid) {
      menuItems.removeAt(1);
    }
    return menuItems;
  }

  Widget get colorSchemeName {
    DropdownMenuItem value = dropdownColorSchemeItems.firstWhere((element) =>
        element.value == _shared.colorScheme ||
        (element.value == AppColorScheme.defaultAppColorScheme &&
            _shared.colorScheme == null));
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

  Widget get appIconName {
    List<DropdownMenuItem<AppIcon?>> list = AppIcon.values
        .map(
          (e) => DropdownMenuItem<AppIcon?>(
            value: e,
            child: Text(SharedService.getAppIconTranslation(e)),
          ),
        )
        .toList();
    list.insert(
      0,
      DropdownMenuItem<AppIcon?>(
        value: null,
        child: Text(SharedService.getAppIconTranslation(null)),
      ),
    );

    DropdownMenuItem value =
        list.firstWhere((element) => element.value == _shared.appIcon);
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
    AppColorScheme? value = await showDialog<AppColorScheme?>(
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

    if (value != null) {
      if (_shared.colorScheme != value) {
        setState(() {
          _shared.colorScheme = value;
        });
        reload();
      }
    }
  }

  Future<void> _askAppIcon() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        fullscreenDialog: true,
        settings: const RouteSettings(name: 'SelectAppIcon'),
        builder: (BuildContext context) => const SelectAppIconPage(),
      ),
    );
    return Future.value(null);
  }

  Future<void> _goToHealthIntegration() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        fullscreenDialog: true,
        settings: const RouteSettings(name: 'HealthIntegration'),
        builder: (BuildContext context) => const HealthIntegrationPage(),
      ),
    );
    return Future.value(null);
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
    _localAuth
        .authenticate(AppLocalizations.of(context)!.requireAuthToConfirm)
        .then(
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
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.sensitiveMode),
        subtitle: Text(
          AppLocalizations.of(context)!.sensitiveModeDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _shared.sensitiveMode,
        onChanged: (bool value) {
          setState(() {
            _shared.sensitiveMode = value;
          });
        },
        secondary: Icon(
          Icons.no_adult_content,
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
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.trueBlack),
        subtitle: Text(
          AppLocalizations.of(context)!.trueBlackDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _shared.trueBlack,
        onChanged: (bool value) {
          setState(() {
            _shared.trueBlack = value;
          });
          reload();
        },
        secondary: Icon(
          Icons.dark_mode,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.material),
        subtitle: Text(
          AppLocalizations.of(context)!.materialDescription,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        value: _shared.material,
        onChanged: (bool value) {
          setState(() {
            _shared.material = value;
          });
          reload();
        },
        secondary: Icon(
          Icons.android,
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
    ];

    if (!kIsWeb) {
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
        list.length - 2,
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
        list.length - 4,
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

    if (isHealthIntegrationAvailable) {
      list.insert(
        list.length - 2,
        ListTile(
          title: Text(AppLocalizations.of(context)!.healthIntegration),
          subtitle: Text(
            AppLocalizations.of(context)!.healthIntegrationDescription,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          onTap: _goToHealthIntegration,
          leading: Icon(
            Icons.medical_information,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    if (_shared.packageInfo != null) {
      list.add(
        ListTile(
          title: Text(AppLocalizations.of(context)!.version),
          subtitle: Text(
            "${_shared.packageInfo?.version ?? '1.0.0'} (${_shared.packageInfo?.buildNumber ?? 1}) ${installerStore ?? 'store'}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          leading: Icon(
            Icons.app_settings_alt,
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
        controller: _scrollController,
        slivers: <Widget>[
          GenericHeader(
            title: Text(AppLocalizations.of(context)!.settings),
            scrolled: _isScrolled,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).padding.left,
              0,
              MediaQuery.of(context).padding.right,
              MediaQuery.of(context).padding.bottom,
            ),
            sliver: SliverList.list(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}
