import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/forms/login_form.dart';
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

  signOut() {
    _common.signOut();
    reload();
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
          value: "monochrome",
          child: Text(AppLocalizations.of(context)!.monochrome)),
    ];
    return menuItems;
  }

  Widget get colorSchemeName {
    DropdownMenuItem value = dropdownColorSchemeItems.firstWhere((element) =>
        element.value == _common.colorScheme ||
        (element.value == "default" && _common.colorScheme == null));
    return value.child;
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
    return value.child;
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

  List<Widget> get items {
    List<Widget> list = [
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.requireAuth),
        subtitle: Text(
          AppLocalizations.of(context)!.requireAuthDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: _common.requireAuth,
        onChanged: (bool value) {
          setState(() {
            _common.requireAuth = value;
          });
        },
        secondary: const Icon(Icons.fingerprint),
      ),
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.privacyMode),
        subtitle: Text(
          AppLocalizations.of(context)!.privacyModeDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: _common.privacyMode,
        onChanged: (bool value) {
          setState(() {
            _common.privacyMode = value;
          });
        },
        secondary: const Icon(Icons.visibility_off),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.appearance),
        subtitle: themeName,
        onTap: _askTheme,
        leading: const Icon(Icons.dark_mode),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.colorScheme),
        subtitle: colorSchemeName,
        onTap: _askColorScheme,
        leading: const Icon(Icons.color_lens),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearPersonalData),
        subtitle: Text(
          AppLocalizations.of(context)!.clearPersonalDataDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: _askClearPersonalData,
        leading: const Icon(Icons.delete),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearData),
        subtitle: Text(
          AppLocalizations.of(context)!.clearDataDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: _askClearData,
        leading: const Icon(Icons.delete_forever),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.version),
        subtitle: Text(
          "${_common.packageInfo?.version ?? '1.0.0'} (${_common.packageInfo?.buildNumber ?? 1}) ${_common.packageInfo?.installerStore ?? 'store'}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        leading: const Icon(Icons.app_settings_alt),
      ),
      _common.isLoggedIn
          ? ListTile(
              title: Text(AppLocalizations.of(context)!.loggedIn),
              leading: const Icon(Icons.person),
              trailing: FilledButton.tonal(
                onPressed: signOut,
                child: Text(AppLocalizations.of(context)!.signOut),
              ),
            )
          : const LoginForm(),
    ];
    if (kDebugMode) {
      list.addAll(
        [
          ListTile(
            title: Text(AppLocalizations.of(context)!.initialFetch),
            leading: const Icon(Icons.download),
            onTap: _common.initialFetch,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.fetchStaticData),
            leading: const Icon(Icons.download),
            onTap: _common.fetchStaticData,
          ),
        ],
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
          ),
          SliverList.list(
            children: items,
          )
        ],
      ),
    );
  }
}
