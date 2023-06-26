import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';

class ActivityEditPage extends StatefulWidget {
  const ActivityEditPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit activity'),
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
