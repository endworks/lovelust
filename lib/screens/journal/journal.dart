import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/activity_item.dart';
import 'package:lovelust/widgets/generic_header.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final SharedService _common = getIt<SharedService>();
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final ScrollController _scrollController = ScrollController();
  List<Activity> _activity = [];
  bool isExtended = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        isExtended = _scrollController.offset <= 0.0;
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

  Future<void> refresh() async {
    if (_common.isLoggedIn) {
      _activity = await _api.getActivity();
    } else {
      _activity = await _storage.getActivity();
    }
    _common.activity = _activity;
    setState(() {
      _activity = _activity;
    });
  }

  void menuEntryItemSelected(FilterEntryItem item) {
    debugPrint(item.name);
    setState(() {
      _common.activityFilter = item.name;
      if (_common.activityFilter == 'all') {
        _activity = _common.activity;
      } else if (_common.activityFilter == 'activity') {
        _activity = _common.activity
            .where(
              (i) => i.type != 'MASTURBATION',
            )
            .toList();
      } else if (_common.activityFilter == 'solo') {
        _activity = _common.activity
            .where(
              (i) => i.type == 'MASTURBATION',
            )
            .toList();
      }
    });
    setState(() {});
    _scrollController.jumpTo(0);
    debugPrint('toggleFilter: ${_common.activityFilter}');
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
      body: RefreshIndicator.adaptive(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            GenericHeader(
              title: Text(AppLocalizations.of(context)!.journal),
              actions: [
                PopupMenuButton(
                  // icon: const Icon(Icons.filter),
                  onSelected: menuEntryItemSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<FilterEntryItem>>[
                    PopupMenuItem(
                      value: FilterEntryItem.all,
                      child: Text(AppLocalizations.of(context)!.allEntries),
                    ),
                    PopupMenuItem(
                      value: FilterEntryItem.activity,
                      child: Text(AppLocalizations.of(context)!.onlySex),
                    ),
                    PopupMenuItem(
                      value: FilterEntryItem.solo,
                      child: Text(AppLocalizations.of(context)!.onlySolo),
                    ),
                  ],
                ),
              ],
            ),
            SliverList.builder(
              itemCount: _activity.length,
              itemBuilder: (context, index) => ActivityItem(
                key: Key(_activity[index].id),
                activity: _activity[index],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isExtended
          ? FloatingActionButton.extended(
              onPressed: addActivity,
              label: Text(AppLocalizations.of(context)!.logActivity),
              icon: const Icon(Icons.post_add),
            )
          : FloatingActionButton(
              onPressed: addActivity,
              tooltip: AppLocalizations.of(context)!.logActivity,
              child: const Icon(Icons.post_add),
            ),
    );
  }
}
