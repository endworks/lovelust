import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/forms/login_form.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

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
    setState(() {
      _common.theme = value ?? 'system';
    });
    reload();
  }

  changeColorScheme(String? value) {
    setState(() {
      _common.colorScheme = value;
    });
    reload();
  }

  changePrivacyMode(bool? value) {
    setState(() {
      _common.privacyMode = value ?? false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(children: [
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
              _common.isLoggedIn
                  ? FilledButton.tonal(
                      onPressed: signOut,
                      child: Text(AppLocalizations.of(context)!.signOut),
                    )
                  : const LoginForm(),
              FilledButton.tonal(
                onPressed: _common.clearData,
                child: Text(AppLocalizations.of(context)!.clearData),
              ),
              FilledButton.tonal(
                onPressed: _common.initialFetch,
                child: Text(AppLocalizations.of(context)!.initialFetch),
              ),
              FilledButton.tonal(
                onPressed: _common.fetchStaticData,
                child: Text(AppLocalizations.of(context)!.fetchStaticData),
              ),
              DropdownButton(
                value: _common.theme,
                items: dropdownThemeItems,
                onChanged: changeTheme,
              ),
              DropdownButton(
                value: _common.colorScheme,
                items: dropdownColorSchemeItems,
                onChanged: changeColorScheme,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
