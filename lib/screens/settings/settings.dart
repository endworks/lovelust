import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/forms/login_form.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();

  reload() {
    Phoenix.rebirth(context);
  }

  signOut() {
    common.signOut();
    reload();
  }

  void changeTheme(String? value) {
    setState(() {
      common.theme = value ?? 'system';
    });
    reload();
  }

  changeColorScheme(String? value) {
    setState(() {
      common.colorScheme = value ?? 'dynamic';
    });
    reload();
  }

  List<DropdownMenuItem<String>> get dropdownColorSchemeItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: 'default', child: Text("Default")),
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
              common.isLoggedIn
                  ? FilledButton.tonal(
                      onPressed: signOut,
                      child: const Text('Sign out'),
                    )
                  : const LoginForm(),
              FilledButton.tonal(
                onPressed: common.clearData,
                child: const Text('Clear data'),
              ),
              FilledButton.tonal(
                onPressed: common.initialFetch,
                child: const Text('Initial fetch'),
              ),
              FilledButton.tonal(
                onPressed: common.fetchStaticData,
                child: const Text('Fetch static data'),
              ),
              DropdownButton(
                value: common.theme,
                items: dropdownThemeItems,
                onChanged: changeTheme,
              ),
              DropdownButton(
                value: common.colorScheme,
                items: dropdownColorSchemeItems,
                onChanged: changeColorScheme,
              )
            ])
          ],
        ),
      ),
    );
  }
}
