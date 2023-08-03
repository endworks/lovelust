import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/activity_card.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final SharedService _shared = getIt<SharedService>();
  final NavigationService _navigator = getIt<NavigationService>();
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final ScrollController _scrollController = ScrollController();
  bool isExtended = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        isExtended = _scrollController.offset <= 0.0;
      });
    });

    _shared.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void addActivity() {
    _navigator.navigateTo(
      MaterialPageRoute<Widget>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return const ActivityAddPage();
          }),
    );
  }

  Future<void> refresh() async {
    if (_shared.isLoggedIn) {
      _shared.activity = await _api.getActivity();
    } else {
      _shared.activity = await _storage.getActivity();
    }
  }

  void menuEntryItemSelected(FilterEntryItem item) {
    setState(() {
      _shared.activityFilter = item.name;
    });
    _scrollController.jumpTo(0);
  }

  List<Activity> get filteredActivity {
    if (_shared.activityFilter == 'activity') {
      return _shared.activity
          .where(
            (i) => i.type == ActivityType.sexualIntercourse,
          )
          .toList();
    } else if (_shared.activityFilter == 'solo') {
      return _shared.activity
          .where(
            (i) => i.type == ActivityType.masturbation,
          )
          .toList();
    } else {
      return _shared.activity;
    }
  }

  Widget separator(int index) {
    final date = filteredActivity[index].date;
    final date2 = filteredActivity[index + 1].date;
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
      body: RefreshIndicator(
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
            filteredActivity.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                        message: AppLocalizations.of(context)!.noActivity),
                  )
                : SliverList.builder(
                    itemCount: filteredActivity.length,
                    itemBuilder: (context, index) => ActivityCard(
                      key: Key(filteredActivity[index].id!),
                      activity: filteredActivity[index],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: isExtended
          ? FloatingActionButton.extended(
              onPressed: addActivity,
              label: Text(AppLocalizations.of(context)!.logActivity),
              heroTag: "journalAddExtended",
              icon: const Icon(Icons.post_add_outlined),
            )
          : FloatingActionButton(
              onPressed: addActivity,
              tooltip: AppLocalizations.of(context)!.logActivity,
              heroTag: "journalAdd",
              child: const Icon(Icons.post_add_outlined),
            ),
    );
  }
}
