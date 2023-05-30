import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        /*backgroundColor: isDarkMode
            ? Theme.of(context).colorScheme.background
            : widget.destination.color[100],*/
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
