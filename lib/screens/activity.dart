import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/widgets/activity_card.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  void _addActivity() {
    setState(() {});
  }

  List<Widget> _activityList() {
    List<Widget> list = [];
    for (var i = 0; i < 10; i++) {
      list.add(
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 8), child: ActivityCard()),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.destination.title),
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant),
      body: ListView(
        children: _activityList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Add activity',
        isExtended: true,
        child: const Icon(Icons.add),
      ),
    );
  }
}
