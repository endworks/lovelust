import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.destination});

  final Destination destination;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
