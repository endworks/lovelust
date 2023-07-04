import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/journal/activity_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/activity_item.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final StorageService storageService = getIt<StorageService>();
  final ApiService api = getIt<ApiService>();
  List<Activity> activity = [];
  ScrollController scrollController = ScrollController();
  bool isExtended = true;

  void addActivity() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return const ActivityAddPage();
          }),
    );
  }

  Future<void> refresh() async {
    activity = await api.getActivity();
    await storageService.setActivity(activity);
    setState(() {
      activity = activity;
    });
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
    scrollController.addListener(() {
      setState(() {
        isExtended = scrollController.offset <= 0.0;
      });
    });

    setState(() {
      activity = storageService.activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.separated(
          controller: scrollController,
          separatorBuilder: (context, index) => const Divider(height: 0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: activity.length,
          itemBuilder: (context, index) =>
              ActivityItem(activity: activity[index]),
        ),
      ),
      floatingActionButton: isExtended
          ? FloatingActionButton.extended(
              onPressed: addActivity,
              label: const Text('Add activity'),
              icon: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: addActivity,
              tooltip: 'Add activity',
              child: const Icon(Icons.add),
            ),
    );
  }
}
