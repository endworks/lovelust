import 'package:flutter/material.dart';
import 'package:lovelust/forms/login_form.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final StorageService storageService = getIt<StorageService>();

  signOut() {
    setState(() {
      storageService.setAccessToken(null);
      storageService.setRefreshToken(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            storageService.accessToken == null
                ? const LoginForm()
                : FilledButton.tonal(
                    onPressed: signOut,
                    child: const Text('Sign out'),
                  )
          ],
        ),
      ),
    );
  }
}
