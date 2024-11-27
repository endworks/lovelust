import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/models/auth_tokens.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final SharedService _shared = getIt<SharedService>();
  final ApiService api = getIt<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  reload() {
    Phoenix.rebirth(context);
  }

  bool get valid =>
      usernameController.value.text.isNotEmpty &&
      passwordController.value.text.isNotEmpty;

  void submit() async {
    AuthTokens tokens;
    if (formKey.currentState!.validate()) {
      if (valid) {
        try {
          tokens = await api.login(
              usernameController.value.text, passwordController.value.text);
          _shared.accessToken = tokens.accessToken;
          _shared.refreshToken = tokens.refreshToken;
          debugPrint('successful login');
          await _shared.initialFetch();
          reload();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$e'),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  labelText: AppLocalizations.of(context)!.username,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                  labelText: AppLocalizations.of(context)!.password,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FilledButton.tonal(
                onPressed: submit,
                child: Text(AppLocalizations.of(context)!.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
