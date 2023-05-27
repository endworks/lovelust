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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        backgroundColor: isDarkMode
            ? Theme.of(context).colorScheme.background
            : widget.destination.color[100],
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
