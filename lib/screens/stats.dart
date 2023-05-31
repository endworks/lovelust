import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
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
