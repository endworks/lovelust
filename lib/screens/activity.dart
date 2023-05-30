import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/widgets/activity_item.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.destination.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: ListView(
        children: const <Widget>[
          ActivityItem(),
          ActivityItem(),
          ActivityItem(),
          ActivityItem(),
          ActivityItem(),
          ActivityItem(),
          ActivityItem(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        isExtended: true,
        label: const Text('Add activity'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
