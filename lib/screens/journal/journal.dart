import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/screens/journal/activity_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/activity_item.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();
  List<Activity> _activity = [];
  ScrollController scrollController = ScrollController();
  bool isExtended = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        isExtended = scrollController.offset <= 0.0;
      });
    });

    setState(() {
      _activity = _common.activity;
    });
  }

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

  void toggleFilter() {
    setState(() {
      if (_common.activityFilter == 'all') {
        _common.activityFilter = 'activity';
        _activity = _common.activity
            .where(
              (i) => i.type != 'MASTURBATION',
            )
            .toList();
      } else if (_common.activityFilter == 'activity') {
        _common.activityFilter = 'solo';
        _activity = _common.activity
            .where(
              (i) => i.type == 'MASTURBATION',
            )
            .toList();
      } else if (_common.activityFilter == 'solo') {
        _common.activityFilter = 'all';
        _activity = _common.activity;
      }
    });
    debugPrint('toggleFilter: ${_common.activityFilter}');
  }

  Icon get toggleIcon {
    if (_common.activityFilter == 'activity') {
      return const Icon(Icons.groups);
    } else if (_common.activityFilter == 'solo') {
      return const Icon(Icons.front_hand);
    } else {
      return const Icon(Icons.all_inclusive);
    }
  }

  Future<void> refresh() async {
    _activity = await _api.getActivity();
    _common.activity = _activity;
    setState(() {
      _activity = _activity;
    });
  }

  Widget separator(int index) {
    final date = _activity[index].date;
    final date2 = _activity[index + 1].date;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
        actions: [
          IconButton(
            onPressed: toggleFilter,
            icon: toggleIcon,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.separated(
          controller: scrollController,
          separatorBuilder: (context, index) => const Divider(height: 0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _activity.length,
          itemBuilder: (context, index) =>
              ActivityItem(activity: _activity[index]),
        ),
      ),
      floatingActionButton: isExtended
          ? FloatingActionButton.extended(
              onPressed: addActivity,
              label: const Text('Log activity'),
              icon: const Icon(Icons.post_add),
            )
          : FloatingActionButton(
              onPressed: addActivity,
              tooltip: 'Log activity',
              child: const Icon(Icons.post_add),
            ),
    );
  }
}
