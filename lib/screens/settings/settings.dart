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

  Future<List<dynamic>> loadData() {
    debugPrint('loadData settings');
    var futures = <Future>[
      storage.getTheme(),
      storage.getColorScheme(),
      storage.getAccessToken(),
    ];
    return Future.wait(futures);
  }

  reload() {
    Phoenix.rebirth(context);
  }

  signOut() {
    common.signOut();
    setState(() {});
  }

  List<DropdownMenuItem<String>> get dropdownColorSchemeItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "dynamic", child: Text("Dynamic")),
      const DropdownMenuItem(value: "lovelust", child: Text("LoveLust")),
      const DropdownMenuItem(value: "love", child: Text("Love")),
      const DropdownMenuItem(value: "lust", child: Text("Lust")),
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
    return FutureBuilder<List<dynamic>>(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) =>
          Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(children: [
                common.isLoggedIn()
                    ? FilledButton.tonal(
                        onPressed: signOut,
                        child: const Text('Sign out'),
                      )
                    : const LoginForm(),
                FilledButton.tonal(
                  onPressed: common.initialFetch,
                  child: const Text('Refresh initial data'),
                ),
                FilledButton.tonal(
                  onPressed: common.fetchStaticData,
                  child: const Text('Refresh static data'),
                ),
                DropdownButton(
                  value: storage.theme,
                  items: dropdownThemeItems,
                  onChanged: (String? value) {
                    storage.setTheme(value ?? 'system');
                    setState(() {
                      storage.theme = storage.theme;
                    });
                    reload();
                  },
                ),
                DropdownButton(
                  value: storage.colorScheme,
                  items: dropdownColorSchemeItems,
                  onChanged: (String? value) {
                    storage.setColorScheme(value ?? 'dynamic');
                    setState(() {
                      storage.colorScheme = storage.colorScheme;
                    });
                    reload();
                  },
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
