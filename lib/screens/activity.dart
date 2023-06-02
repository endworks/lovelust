import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/screens/activity_details.dart';
import 'package:lovelust/widgets/activity_card.dart';
import 'package:lovelust/widgets/activity_item.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final storage = const FlutterSecureStorage();
  String? accessToken;
  bool calendarView = false;
  List<Activity> activity = [];

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
      setState(() {
        activity = jsonDecode(persistedActivity)
            .map<Activity>((map) => Activity.fromJson(map))
            .toList();
      });
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

  Future<void> _pullRefresh() async {
    activity = await _getActivity();
    setState(() {
      activity = activity;
    });
  }

  Widget _separator(int index) {
    final date = activity[index].date;
    final date2 = activity[index + 1].date;
    final difference = date.difference(date2).inDays;
    if (difference > 0) {
      return Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(difference > 1 ? '$difference days' : '$difference day',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceVariant)),
              ]));
    }
    return const Divider(
      indent: 16,
      endIndent: 16,
      height: 0,
      thickness: 0,
      color: Colors.transparent,
    );
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _readData().then((value) async {
        if (accessToken != null && activity.isEmpty) {
          activity = await _getActivity();
          setState(() {
            activity = activity;
          });
          await storage.write(key: 'activity', value: jsonEncode(activity));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary
        actions: [
          IconButton(
            icon: Icon(calendarView ? Icons.view_stream : Icons.calendar_today),
            onPressed: () {
              debugPrint(calendarView ? 'list' : 'calendar');
              setState(() => calendarView = !calendarView);
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.separated(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              separatorBuilder: (context, index) => _separator(index),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: activity.length,
              itemBuilder: (context, index) => !calendarView
                  ? ActivityCard(activity: activity[index])
                  : ActivityItem(activity: activity[index]))),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Add activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}
