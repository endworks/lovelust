import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.destination.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
