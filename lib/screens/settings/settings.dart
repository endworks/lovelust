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
          value: null,
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

  List<DropdownMenuItem<bool>> get dropdownPrivacyModeItems {
    List<DropdownMenuItem<bool>> menuItems = [
      DropdownMenuItem(
          value: true,
          child: Text(AppLocalizations.of(context)!.privacyModeOn)),
      DropdownMenuItem(
          value: false,
          child: Text(AppLocalizations.of(context)!.privacyModeOff)),
    ];
    return menuItems;
  }

  List<Widget> get items {
    List<Widget> list = [
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
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.requireAuth),
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
        leading: const Icon(Icons.dark_mode),
        trailing: DropdownButton(
          value: _common.theme,
          items: dropdownThemeItems,
          onChanged: changeTheme,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.colorScheme),
        leading: const Icon(Icons.color_lens),
        trailing: DropdownButton(
          value: _common.colorScheme,
          items: dropdownColorSchemeItems,
          onChanged: changeColorScheme,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearData),
        leading: const Icon(Icons.delete),
        trailing: FilledButton.tonal(
          onPressed: _common.clearData,
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ),
    ];
    if (kDebugMode) {
      list.addAll(
        [
          ListTile(
            title: Text(AppLocalizations.of(context)!.initialFetch),
            leading: const Icon(Icons.download),
            trailing: FilledButton.tonal(
              onPressed: _common.initialFetch,
              child: Text(AppLocalizations.of(context)!.fetch),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.fetchStaticData),
            leading: const Icon(Icons.download),
            trailing: FilledButton.tonal(
              onPressed: _common.fetchStaticData,
              child: Text(AppLocalizations.of(context)!.fetch),
            ),
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
