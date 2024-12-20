import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/screens/journal/activity_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/activity_calendar.dart';
import 'package:lovelust/widgets/activity_card.dart';
import 'package:lovelust/widgets/activity_filters.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final SharedService _shared = getIt<SharedService>();
  final StorageService _storage = getIt<StorageService>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<State<StatefulWidget>> fabKey = GlobalKey();
  Size? fabSize;
  bool _isExtended = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _isExtended = _scrollController.offset <= 0.0;
      });
    });
    _shared.addListener(() {
      if (mounted) {
        setState(() {
          if (_shared.material) {
            final box = fabKey.currentContext?.findRenderObject();
            fabSize = (box as RenderBox).size;
          }
        });
      }
    });
  }

  List<Widget> get slivers {
    List<Widget> slivers = [];
    if (_shared.calendarView) {
      slivers.add(
        SliverToBoxAdapter(
          child: ActivityCalendar(),
        ),
      );
    } else {
      if (_shared.stats.lastSexualActivity != null &&
          _shared.stats.lastMasturbation != null) {
        slivers.add(
          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            sliver: SliverToBoxAdapter(
              child: ActivityFilters(),
            ),
          ),
        );
      }
    }

    if (filteredActivity.isEmpty) {
      if (!_shared.calendarView) {
        slivers.add(
          SliverFillRemaining(
            child: NoContent(
              icon: Icons.calendar_today,
              message: AppLocalizations.of(context)!.noActivity,
            ),
          ),
        );
      } else {
        slivers.add(
          SliverToBoxAdapter(
            child: NoContent(
              icon: Icons.calendar_today,
              message: AppLocalizations.of(context)!.noActivityToday,
            ),
          ),
        );
      }
    } else {
      slivers.add(
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).padding.left,
            0,
            MediaQuery.of(context).padding.right,
            MediaQuery.of(context).padding.bottom,
          ),
          sliver: SliverList.builder(
            itemCount: filteredActivity.length,
            itemBuilder: (context, index) => ActivityCard(
              key: ObjectKey(filteredActivity[index].id!),
              activity: filteredActivity[index],
            ),
          ),
        ),
      );
    }

    return slivers;
  }

  void addActivity() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        fullscreenDialog: true,
        settings: const RouteSettings(name: 'ActivityAdd'),
        builder: (BuildContext context) => const ActivityAddPage(),
      ),
    );
  }

  Future<void> refresh() async {
    _shared.activity = await _storage.getActivity();
  }

  List<Activity> get filteredActivity {
    if (!_shared.calendarView) {
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
    } else {
      return _shared.activity
          .where(
            (i) =>
                i.date.year == _shared.calendarDate.year &&
                i.date.month == _shared.calendarDate.month &&
                i.date.day == _shared.calendarDate.day,
          )
          .toList();
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
                        color: Theme.of(context).colorScheme.surfaceDim)),
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
          physics: filteredActivity.isNotEmpty || _shared.calendarView
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            GenericHeader(
              title: Text(AppLocalizations.of(context)!.journal),
              /*bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    child: CalendarViewToggle(),
                  ),
                ),
              ),*/
              actions: [
                _shared.calendarView
                    ? IconButton(
                        icon: Icon(
                          Icons.today,
                        ),
                        onPressed: !_shared.isToday
                            ? () {
                                _shared.calendarDate = DateTime.now();
                                _scrollController.jumpTo(0);
                              }
                            : null,
                      )
                    : SizedBox.shrink(),
                FilledButton.tonalIcon(
                    onPressed: () {
                      _shared.calendarView = !_shared.calendarView;
                      HapticFeedback.selectionClick();
                    },
                    icon: Icon(
                      _shared.calendarView
                          ? Icons.view_timeline_outlined
                          : Icons.calendar_today_outlined,
                    ),
                    label: _shared.calendarView
                        ? Text(AppLocalizations.of(context)!.timeline)
                        : Text(AppLocalizations.of(context)!.calendar)),
                !_shared.material
                    ? IconButton(
                        icon: Icon(Icons.post_add),
                        onPressed: addActivity,
                      )
                    : SizedBox.shrink(),
              ],
              scrolled: !_isExtended,
            ),
            ...slivers,
          ],
        ),
      ),
      floatingActionButton: _shared.material
          ? Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).padding.bottom
                        : 0,
              ),
              child: AnimatedContainer(
                width: _isExtended ? fabSize?.width : fabSize?.height,
                height: fabSize?.height,
                duration: Duration(milliseconds: 100),
                child: FloatingActionButton.extended(
                  onPressed: addActivity,
                  key: fabKey,
                  heroTag: "journalAdd",
                  label: AnimatedSize(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.linear,
                    child: Container(
                      child: _isExtended
                          ? Text(
                              AppLocalizations.of(context)!.logActivity,
                            )
                          : Icon(
                              Icons.post_add_outlined,
                            ),
                    ),
                  ),
                  icon: _isExtended ? Icon(Icons.post_add_outlined) : null,
                ),
              ),
            )
          : null,
    );
  }
}
