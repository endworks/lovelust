import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      // backgroundColor: destination.color[50],
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
