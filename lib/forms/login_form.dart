import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/auth_tokens.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() async {
    const storage = FlutterSecureStorage();
    AuthTokens tokens;
    if (formKey.currentState!.validate()) {
      bool valid = usernameController.value.text.isNotEmpty &&
          passwordController.value.text.isNotEmpty;
      if (valid) {
        try {
          tokens = await signIn(
              usernameController.value.text, passwordController.value.text);
          await storage.write(key: 'access_token', value: tokens.accessToken);
          await storage.write(key: 'refresh_token', value: tokens.refreshToken);
          Navigator.pop(context);
        } on SocketException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Internet connection 😑'),
            ),
          );
        } on HttpException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't find the post 😱"),
            ),
          );
        } on FormatException {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bad response format 👎'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextField(
              controller: usernameController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
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
