import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/forms/login_form.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final CommonService _common = getIt<CommonService>();

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
      const DropdownMenuItem(value: null, child: Text("Default")),
      const DropdownMenuItem(value: "dynamic", child: Text("Dynamic")),
      const DropdownMenuItem(value: "love", child: Text("Love")),
      const DropdownMenuItem(value: "lust", child: Text("Lust")),
      const DropdownMenuItem(value: "lovelust", child: Text("LoveLust")),
      const DropdownMenuItem(value: "lustfullove", child: Text("Lustful love")),
      const DropdownMenuItem(value: "lovefullust", child: Text("Loveful lust")),
      const DropdownMenuItem(value: "monochrome", child: Text("Monochrome")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownThemeItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "system", child: Text("System")),
      const DropdownMenuItem(value: "light", child: Text("Light")),
      const DropdownMenuItem(value: "dark", child: Text("Dark")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<bool>> get dropdownPrivacyModeItems {
    List<DropdownMenuItem<bool>> menuItems = [
      const DropdownMenuItem(value: true, child: Text("Privacy mode ON")),
      const DropdownMenuItem(value: false, child: Text("Privacy mode OFF")),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(children: [
              _common.isLoggedIn
                  ? FilledButton.tonal(
                      onPressed: signOut,
                      child: const Text('Sign out'),
                    )
                  : const LoginForm(),
              FilledButton.tonal(
                onPressed: _common.clearData,
                child: const Text('Clear data'),
              ),
              FilledButton.tonal(
                onPressed: _common.initialFetch,
                child: const Text('Initial fetch'),
              ),
              FilledButton.tonal(
                onPressed: _common.fetchStaticData,
                child: const Text('Fetch static data'),
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
              DropdownButton(
                value: _common.privacyMode,
                items: dropdownPrivacyModeItems,
                onChanged: changePrivacyMode,
              )
            ])
          ],
        ),
      ),
    );
  }
}
