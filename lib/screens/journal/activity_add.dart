import 'package:flutter/material.dart';

class ActivityAddPage extends StatefulWidget {
  const ActivityAddPage({super.key});

  @override
  State<ActivityAddPage> createState() => _ActivityAddPageState();
}

class _ActivityAddPageState extends State<ActivityAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add activity'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
