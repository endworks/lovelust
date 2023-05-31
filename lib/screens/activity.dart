import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/activity_details.dart';
import 'package:lovelust/widgets/activity_card.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final storage = const FlutterSecureStorage();
  String? accessToken;
  List<Activity> activity = [];
  List<Widget> list = [];

  void _addActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return const ActivityDetailsPage();
    }));
  }

  Future<void> _readData() async {
    accessToken = await storage.read(key: 'access_token');
    final persistedActivity = await storage.read(key: 'activity');
    if (persistedActivity != null) {
      activity = jsonDecode(persistedActivity)
          .map<Activity>((map) => Activity.fromJson(map))
          .toList();
    }
  }

  Future<List<Activity>> _getActivity() async {
    final response = await http.get(
      Uri.parse('https://lovelust-api.end.works/activity'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Activity>((map) => Activity.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load activity');
    }
  }

  List<Widget> _activityList() {
    return activity.map((entry) {
      return ActivityCard(activity: entry);
    }).toList();
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _readData().then((value) async {
        activity = await _getActivity();
        await storage.write(key: 'activity', value: jsonEncode(activity));

        setState(() {
          list = _activityList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: ListView(
        children: list,
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
