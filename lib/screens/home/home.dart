import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';
import 'package:lovelust/widgets/statistics/dynamic_statistic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SharedService _shared = getIt<SharedService>();
  List<Widget> _statistics = [];

  @override
  void initState() {
    super.initState();
    _statistics = generateStatistics();

    _shared.addListener(() {
      if (mounted) {
        setState(() {
          _statistics = generateStatistics();
        });
      }
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'Settings'),
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  Color generateAltColor(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    return hslColor.withHue(hslColor.hue - 20).toColor();
  }

  Widget get title {
    Color colorLove = generateAltColor(Theme.of(context).colorScheme.primary);
    Color colorLust = Theme.of(context).colorScheme.primary;

    if (_shared.colorScheme == null) {
      colorLove = loveColor;
      colorLust = lustColor;
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Love', style: TextStyle(color: colorLove)),
          TextSpan(text: 'Lust', style: TextStyle(color: colorLust)),
        ],
      ),
    );
  }

  List<Widget> generateStatistics() {
    List<DynamicStatisticData> list = [];
    Activity? lastRelationship = _shared.activity.firstWhereOrNull(
        (element) => element.type == ActivityType.sexualIntercourse);
    if (lastRelationship != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastRelationship,
          date: lastRelationship.date,
          data: lastRelationship,
        ),
      );
    }

    Activity? lastMasturbation = _shared.activity.firstWhereOrNull(
        (element) => element.type == ActivityType.masturbation);
    if (lastMasturbation != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastMasturbation,
          date: lastMasturbation.date,
          data: lastMasturbation,
        ),
      );
    }

    DateTime daysWithoutSexDate = DateTime.now();
    int lastRelationshipDays = -1;
    if (lastRelationship != null) {
      lastRelationshipDays =
          (DateTime.now().difference(lastRelationship.date).inHours / 24)
              .floor();
    }
    int lastMasturbationDays = -1;
    if (lastMasturbation != null) {
      lastMasturbationDays =
          (DateTime.now().difference(lastMasturbation.date).inHours / 24)
              .floor();
    }
    if (lastRelationship != null && lastMasturbation != null) {
      daysWithoutSexDate =
          lastRelationship.date.difference(lastMasturbation.date).inSeconds > 0
              ? lastRelationship.date
              : lastMasturbation.date;
    } else if (lastRelationship != null) {
      daysWithoutSexDate = lastRelationship.date;
    } else if (lastMasturbation != null) {
      daysWithoutSexDate = lastMasturbation.date;
    }
    daysWithoutSexDate = daysWithoutSexDate.add(const Duration(seconds: 1));
    if (lastRelationshipDays > -1 || lastMasturbationDays > -1) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.daysWithoutSex,
          date: daysWithoutSexDate,
          data: DaysWithoutSexData(lastRelationshipDays, lastMasturbationDays),
        ),
      );
    }

    list.sort((a, b) => b.date.compareTo(a.date));
    return list
        .map(
          (e) => DynamicStatistic(
            type: e.type,
            date: e.date,
            data: e.data,
          ),
        )
        .toList();
  }

  Future<void> refresh() async {
    setState(() {
      _statistics = generateStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          physics: _statistics.isNotEmpty
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            GenericHeader(
              title: title,
              actions: [
                IconButton(
                  onPressed: _openSettings,
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            _statistics.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                      icon: Icons.analytics_outlined,
                      message: AppLocalizations.of(context)!.noStatistics,
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).padding.left,
                      0,
                      MediaQuery.of(context).padding.right,
                      MediaQuery.of(context).padding.bottom,
                    ),
                    sliver: SliverList.builder(
                      itemCount: _statistics.length,
                      itemBuilder: (context, index) => _statistics[index],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
