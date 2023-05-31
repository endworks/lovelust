import 'package:flutter/material.dart';

import '../forms/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Sign in'),
      content: LoginForm(),
    );
    /*return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: LoginForm(),
      ),
    );*/
  }
}
