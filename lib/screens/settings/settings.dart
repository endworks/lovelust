import 'package:flutter/material.dart';
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

  signOut() {
    common.signOut();
    setState(() {});
  }

  initialFetch() {
    common.initialFetch();
  }

  fetchStaticData() {
    common.fetchStaticData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: initialFetch,
                child: const Text('Refresh initial data'),
              ),
              FilledButton.tonal(
                onPressed: fetchStaticData,
                child: const Text('Refresh static data'),
              )
            ])
          ],
        ),
      ),
    );
  }
}
