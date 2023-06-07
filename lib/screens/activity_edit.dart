import 'package:flutter/material.dart';

class ActivityEditPage extends StatefulWidget {
  const ActivityEditPage({super.key});

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity edit'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary
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
