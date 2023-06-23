import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/auth_tokens.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final StorageService _storageService = getIt<StorageService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool valid() =>
      usernameController.value.text.isNotEmpty &&
      passwordController.value.text.isNotEmpty;

  void submit() async {
    AuthTokens tokens;
    if (formKey.currentState!.validate()) {
      if (valid()) {
        try {
          tokens = await signIn(
              usernameController.value.text, passwordController.value.text);
          await _storageService.setAccessToken(tokens.accessToken);
          await _storageService.setRefreshToken(tokens.refreshToken);
        } on SocketException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Internet connection!'),
            ),
          );
        } on HttpException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't sign in!"),
            ),
          );
        } on FormatException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bad response format!'),
            ),
          );
        } on Exception {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sign in!'),
            ),
          );
        }
      }
    }
  }

  Future<AuthTokens> signIn(String username, String password) async {
    final response = await http.post(
        Uri.parse('https://lovelust-api.end.works/auth/login'),
        body: {'username': username, 'password': password});

    if (response.statusCode == 201) {
      return AuthTokens.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                filled: true,
                border: UnderlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter username...',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key),
                filled: true,
                border: UnderlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter passsword...',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FilledButton.tonal(
              onPressed: submit,
              child: const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }
}
