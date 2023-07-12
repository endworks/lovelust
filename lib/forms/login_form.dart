import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/models/auth_tokens.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final SharedService _common = getIt<SharedService>();
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
          _common.accessToken = tokens.accessToken;
          _common.refreshToken = tokens.refreshToken;
          debugPrint('successful login');
          await _common.initialFetch();
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
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                filled: true,
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
                prefixIcon: const Icon(Icons.key),
                filled: true,
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
    );
  }
}
