import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/journal/activity_edit.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/activity_card.dart';
import 'package:lovelust/widgets/activity_item.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final StorageService storageService = getIt<StorageService>();
  bool calendarView = false;
  List<Activity> activity = [];

  void addActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return const ActivityEditPage();
    }));
  }

  Future<List<Activity>> getActivity() async {
    final response = await http.get(
      Uri.parse('https://lovelust-api.end.works/activity'),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${await storageService.getAccessToken()}',
      },
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Activity>((map) => Activity.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Future<void> pullRefresh() async {
    activity = await getActivity();
    setState(() {
      activity = activity;
    });
  }

  void onCalendarToggle() async {
    debugPrint(calendarView ? 'list' : 'calendar');
    setState(() => calendarView = !calendarView);
    await storageService.setCalendarView(calendarView);
  }

  Widget separator(int index) {
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
    super.initState();

    if (storageService.accessToken != null && activity.isEmpty) {
      getActivity().then((value) async {
        setState(() {
          activity = value;
        });
        await storageService.setActivity(activity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: Icon(calendarView ? Icons.view_stream : Icons.calendar_today),
            onPressed: onCalendarToggle,
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView.separated(
              padding: !calendarView
                  ? const EdgeInsetsDirectional.symmetric(horizontal: 8)
                  : null,
              // separatorBuilder: (context, index) => _separator(index),
              separatorBuilder: (context, index) =>
                  !calendarView ? separator(index) : const Divider(height: 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: activity.length,
              itemBuilder: (context, index) => !calendarView
                  ? ActivityCard(activity: activity[index])
                  : ActivityItem(activity: activity[index]))),
      floatingActionButton: FloatingActionButton(
        onPressed: addActivity,
        tooltip: 'Add activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}
