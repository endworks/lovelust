import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/activity_widget_data.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/models/settings.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/models/stats.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/statistics/dynamic_statistic.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SharedService extends ChangeNotifier {
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  final NavigationService _navigator = getIt<NavigationService>();

  Settings _settings = defaultSettings;

  List<Activity> _activity = [];
  List<Partner> _partners = [];
  List<Widget> _statistics = [];
  Stats stats = Stats(
    date: DateTime.now(),
    lastSexualActivity: null,
    daysSinceLastSexualActivity: -1,
    lastMasturbation: null,
    daysSinceLastMasturbation: -1,
    daysSinceLastSexualStimulation: 0,
    totalSexualActivity: 0,
    totalSexualActivityWithMale: 0,
    totalSexualActivityWithFemale: 0,
    totalSexualActivityWithUnknown: 0,
    totalMasturbation: 0,
    mostPopularPartner: null,
    mostPopularPractice: null,
    mostPopularMood: null,
    mostPopularEjaculationPlace: null,
    mostPopularPlace: null,
    safetyPercentSafe: 0,
    safetyPercentUnsafe: 0,
    safetyPercentPartlyUnsafe: 0,
    mostActiveYear: null,
    mostActiveMonth: null,
    mostActiveDay: null,
    mostActiveWeekday: null,
    mostActiveHour: null,
    orgasmRatio: 0,
    orgasmsGiven: 0,
    orgasmsReceived: 0,
    averageDuration: 0,
    weeklyStats: {},
    globalStats: {},
    monthlyStats: {},
    yearlyStats: {},
    timeDistributionStats: {},
  );
  bool _protected = false;
  DateTime _calendarSelectedDate = DateTime.now();
  PackageInfo? packageInfo;
  AppLifecycleState appLifecycleState = AppLifecycleState.inactive;

  Future<void> initialLoad() async {
    if (_activity.isEmpty ||
        _partners.isEmpty ||
        _settings == defaultSettings) {
      debugPrint('initialLoad');
      List<Future> futures = <Future>[
        _storage.getSettings(),
        _storage.getActivity(),
        _storage.getPartners(),
        findSystemLocale(),
      ];
      List result = await Future.wait(futures);
      _settings = result[0];
      _activity = result[1];
      _partners = result[2];
      Intl.systemLocale = result[3];

      if (_settings.requireAuth && !authorized) {
        _protected = true;
      }

      await getPackageInfo();
    } else {
      debugPrint('skip initialLoad');
    }
    statistics = generateStatsWidgets();
    notifyListeners();
    updateWidgets();
  }

  reload() {
    BuildContext context = _navigator.navigatorKey.currentContext!;
    Phoenix.rebirth(context);
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    activity = await _api.getActivity();
    partners = await _api.getPartners();
  }

  Future<void> getPackageInfo() async {
    if (!kDebugMode) {
      packageInfo = await PackageInfo.fromPlatform();
    }
  }

  static Color generateAltColor(Color color, {double variation = 30.0}) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double hue = hslColor.hue - variation;
    if (hue > 360) {
      hue = hue - 360;
    }
    if (hue < 0) {
      hue = hue + 360;
    }
    return hslColor.withHue(hue).toColor();
  }

  static Color generateSecondaryColor(Color color, {double saturation = 0.1}) {
    HSLColor hslColor = HSLColor.fromColor(color);
    return hslColor.withSaturation(saturation).toColor();
  }

  List<Widget> generateStatsWidgets() {
    debugPrint('generateStatsWidgets');
    stats = generateStats();
    BuildContext context = _navigator.navigatorKey.currentContext!;
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color blue =
        Colors.blue.harmonizeWith(Theme.of(context).colorScheme.primary);
    Color red = Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
    Color green =
        Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);
    Color orange =
        Colors.orange.harmonizeWith(Theme.of(context).colorScheme.primary);
    Color legend = Color.fromARGB(255, 128, 128, 128);
    Color disabled = Color.fromARGB(32, 128, 128, 128);
    Color lines = Colors.transparent;

    List<DynamicStatisticData> list = [];
    if (stats.lastSexualActivity != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastRelationship,
          date: stats.lastSexualActivity!.date,
          data: stats.lastSexualActivity,
        ),
      );
    }

    if (stats.lastMasturbation != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastMasturbation,
          date: stats.lastMasturbation!.date,
          data: stats.lastMasturbation,
        ),
      );
    }

    if (stats.daysSinceLastSexualActivity > 0 ||
        stats.daysSinceLastMasturbation > 0) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.daysWithoutSex,
          date: stats.daysSinceLastSexualStimulation ==
                  stats.daysSinceLastSexualActivity
              ? stats.lastSexualActivity!.date
              : stats.lastMasturbation!.date,
          data: DaysWithoutSexData(stats.daysSinceLastSexualActivity,
              stats.daysSinceLastMasturbation),
        ),
      );
    }
    if (stats.lastSexualActivity != null || stats.lastMasturbation != null) {
      List<String> barChartTypes = ['weekly', 'monthly', 'yearly', 'global'];
      List<String> pieChartTypes = [
        'safety',
        'timeDistribution',
        'sexDistribution'
      ];

      BarChartData barChartData;
      PieChartData pieChartData;
      double maxWidth = MediaQuery.of(context).size.width;
      double barsSpaceRatio = 0.8;
      List<String> monthNames = DateFormat.EEEE().dateSymbols.SHORTMONTHS;

      for (String chartType in barChartTypes) {
        Map<String, StatsCountTimeData> timeData = {};
        if (chartType == 'weekly') {
          timeData = stats.weeklyStats;
        } else if (chartType == 'monthly') {
          timeData = stats.monthlyStats;
        } else if (chartType == 'yearly') {
          timeData = stats.yearlyStats;
        } else {
          timeData = stats.globalStats;
        }

        double barsSpace = barsSpaceRatio * maxWidth / timeData.length;
        double barsWidth = (1 - barsSpaceRatio) * maxWidth / timeData.length;
        double minBarsWidth = 4;
        double maxBarsWidth = 8;
        if (barsWidth < minBarsWidth) {
          barsWidth = minBarsWidth;
        }
        if (barsWidth > maxBarsWidth) {
          barsWidth = maxBarsWidth;
        }

        List<BarChartGroupData> chartData = [];

        double max = 0;
        int index = 0;
        List<String> keysWithData = [];
        timeData.forEach((String key, StatsCountTimeData data) {
          List<BarChartRodData> barRods = [];
          double currentMax = data.male.toDouble() +
              data.female.toDouble() +
              data.unknown.toDouble() +
              data.masturbation.toDouble();
          if (currentMax > 0) {
            keysWithData.add(key);
            double current = 0;
            if (data.male > 0) {
              barRods.add(
                BarChartRodData(
                  fromY: current,
                  toY: current + data.male.toDouble(),
                  width: barsWidth,
                  borderSide: BorderSide(
                    width: 0,
                    color: blue,
                  ),
                  gradient: LinearGradient(
                    colors: [blue, generateAltColor(blue)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
              current += data.male;
            }
            if (data.female > 0) {
              barRods.add(
                BarChartRodData(
                  fromY: current,
                  toY: current + data.female.toDouble(),
                  width: barsWidth,
                  borderSide: BorderSide(
                    width: 0,
                    color: red,
                  ),
                  gradient: LinearGradient(
                    colors: [red, generateAltColor(red)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
              current += data.female;
            }
            if (data.unknown > 0) {
              barRods.add(
                BarChartRodData(
                  fromY: current,
                  toY: current + data.unknown.toDouble(),
                  width: barsWidth,
                  borderSide: BorderSide(
                    width: 0,
                    color: secondary,
                  ),
                  gradient: LinearGradient(
                    colors: [secondary, generateAltColor(secondary)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
              current += data.unknown;
            }
            if (data.masturbation > 0) {
              barRods.add(
                BarChartRodData(
                  fromY: current,
                  toY: current + data.masturbation.toDouble(),
                  width: barsWidth,
                  borderSide: BorderSide(
                    width: 0,
                    color: primary,
                  ),
                  gradient: LinearGradient(
                    colors: [primary, generateAltColor(primary)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            }
          } else {
            barRods.add(
              BarChartRodData(
                fromY: 0,
                toY: 0.1,
                width: barsWidth,
                color: disabled,
              ),
            );
          }

          if (currentMax > max) {
            max = currentMax;
          }

          chartData.add(
            BarChartGroupData(
              x: index,
              groupVertically: true,
              barRods: barRods,
              barsSpace: barsSpace,
            ),
          );
          index += 1;
        });

        barChartData = BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
            enabled: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  String text;
                  bool showLabel = true;
                  String timeDataValue = timeData[value.toInt().toString()]!.id;
                  if (chartType == 'monthly') {
                    showLabel = (30 - value) % 7 == 0;
                    if (value == 1) {
                      //showLabel = true;
                    }
                  } else if (chartType == 'montly') {
                    showLabel = value.toInt() % 4 == 0;
                  }
                  text = '';
                  if (showLabel) {
                    text = timeDataValue.capitalize();
                    if (chartType == 'monthly') {
                      int monthIndex = stats.date.month - 1;
                      if (int.parse(timeDataValue) > stats.date.day) {
                        monthIndex = stats.date.month - 2;
                      }
                      if (monthIndex < 0) {
                        monthIndex + 12;
                      }
                      text += ' ${monthNames[monthIndex].capitalize()}';
                    }
                  }
                  if (chartType == 'monthly') {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      angle: 45,
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: legend,
                              fontSize: 9,
                            ),
                      ),
                    );
                  } else {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      angle: 0,
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: legend,
                            ),
                      ),
                    );
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 18,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: legend,
                        ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: lines,
              strokeWidth: 0,
            ),
            verticalInterval: 1 / (timeData.length - 1),
            drawVerticalLine: false,
            getDrawingVerticalLine: (value) => FlLine(
              color: lines,
              strokeWidth: 0,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.merge(
              Border(
                bottom: BorderSide(
                  color: lines,
                  width: 2,
                ),
              ),
              Border(
                left: BorderSide(
                  color: lines,
                  width: 2,
                ),
              ),
            ),
          ),
          groupsSpace: barsSpace,
          barGroups: chartData,
        );

        StatisticType type;
        DateTime date;
        if (chartType == 'weekly') {
          type = StatisticType.weeklyChart;
          date = stats.date;
        } else if (chartType == 'monthly') {
          type = StatisticType.monthlyChart;
          date = DateTime(stats.date.year, stats.date.month);
        } else if (chartType == 'yearly') {
          type = StatisticType.yearlyChart;
          date = DateTime(stats.date.year);
        } else {
          type = StatisticType.globalChart;
          date = DateTime(stats.date.year);
        }
        if (keysWithData.isNotEmpty) {
          list.add(
            DynamicStatisticData(
              type: type,
              date: date,
              data: barChartData,
            ),
          );
        }

        if (chartType == 'yearly' && stats.mostActiveMonth != null) {
          list.add(
            DynamicStatisticData(
              type: StatisticType.simple,
              date: DateTime(stats.date.year),
              data: SimpleStatisticData(
                title: AppLocalizations.of(context)!.mostActiveMonth,
                description: stats.mostActiveMonth!.id,
                count: stats.mostActiveMonth!.count.toInt(),
                icon: Icons.calendar_today,
              ),
            ),
          );
        }

        if (chartType == 'global' && stats.mostActiveYear != null) {
          list.add(
            DynamicStatisticData(
              type: StatisticType.simple,
              date: DateTime(stats.date.year),
              data: SimpleStatisticData(
                title: AppLocalizations.of(context)!.mostActiveYear,
                description: stats.mostActiveYear!.id,
                count: stats.mostActiveYear!.count.toInt(),
                icon: Icons.calendar_today,
              ),
            ),
          );
        }
      }
      if (stats.lastSexualActivity != null) {
        for (String chartType in pieChartTypes) {
          List<PieChartSectionData> pieSections = [];
          if (chartType == 'safety') {
            pieSections.addAll([
              PieChartSectionData(
                color: green,
                value: stats.safetyPercentSafe.toDouble(),
                title: '${stats.safetyPercentSafe}%',
                titleStyle: Theme.of(context).textTheme.labelMedium,
                titlePositionPercentageOffset: 1.2,
                radius: stats.safetyPercentSafe.toDouble() * 30 / 100 + 70,
                borderSide: BorderSide.none,
              ),
              PieChartSectionData(
                color: red,
                value: stats.safetyPercentUnsafe.toDouble(),
                title: '${stats.safetyPercentUnsafe}%',
                titleStyle: Theme.of(context).textTheme.labelMedium,
                titlePositionPercentageOffset: 1.2,
                radius: stats.safetyPercentUnsafe.toDouble() * 30 / 100 + 70,
                borderSide: BorderSide.none,
              ),
              PieChartSectionData(
                color: orange,
                value: stats.safetyPercentPartlyUnsafe.toDouble(),
                title: '${stats.safetyPercentPartlyUnsafe}%',
                titleStyle: Theme.of(context).textTheme.labelMedium,
                titlePositionPercentageOffset: 1.2,
                radius:
                    stats.safetyPercentPartlyUnsafe.toDouble() * 30 / 100 + 70,
                borderSide: BorderSide.none,
              )
            ]);
          } else if (chartType == 'timeDistribution') {
            pieSections.addAll(
              stats.timeDistributionStats.entries.map(
                (timeDistribution) {
                  Color color = primary;
                  Color textColor =
                      Theme.of(context).colorScheme.onInverseSurface;
                  String title;
                  if (timeDistribution.value.id == '0') {
                    title = "0-6";
                    color = primary.withValues(alpha: 0.4);
                    color = Colors.deepPurple
                        .harmonizeWith(Theme.of(context).primaryColor);
                  } else if (timeDistribution.value.id == '6') {
                    title = "6-12";
                    color = primary;
                    color = Colors.orange
                        .harmonizeWith(Theme.of(context).primaryColor);
                  } else if (timeDistribution.value.id == '12') {
                    title = "12-18";
                    color = primary.withValues(alpha: 0.8);
                    color = Colors.lightBlue
                        .harmonizeWith(Theme.of(context).primaryColor);
                  } else {
                    title = "18-0";
                    color = primary.withValues(alpha: 0.6);
                    color = Colors.deepOrange
                        .harmonizeWith(Theme.of(context).primaryColor);
                  }

                  return PieChartSectionData(
                    color: color,
                    value: timeDistribution.value.count,
                    title: title,
                    titleStyle: Theme.of(context).textTheme.labelMedium,
                    titlePositionPercentageOffset: 1.2,
                    badgeWidget: Text(
                      timeDistribution.value.count.toInt().toString(),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: textColor,
                          ),
                    ),
                    radius: timeDistribution.value.count * 30 / 100 + 70,
                    borderSide: BorderSide.none,
                  );
                },
              ),
            );
          } else if (chartType == 'sexDistribution') {
            if (stats.totalSexualActivityWithMale > 0) {
              pieSections.add(
                PieChartSectionData(
                  color: blue,
                  value: stats.totalSexualActivityWithMale.toDouble(),
                  title: AppLocalizations.of(context)!.male,
                  titleStyle: Theme.of(context).textTheme.labelMedium,
                  titlePositionPercentageOffset: 1.2,
                  radius: stats.totalSexualActivityWithMale /
                          stats.totalSexualActivity *
                          30 +
                      70,
                  borderSide: BorderSide.none,
                ),
              );
            }
            if (stats.totalSexualActivityWithFemale > 0) {
              pieSections.add(
                PieChartSectionData(
                  color: red,
                  value: stats.totalSexualActivityWithFemale.toDouble(),
                  title: AppLocalizations.of(context)!.female,
                  titleStyle: Theme.of(context).textTheme.labelMedium,
                  titlePositionPercentageOffset: 1.2,
                  radius: stats.totalSexualActivityWithFemale /
                          stats.totalSexualActivity *
                          30 +
                      70,
                  borderSide: BorderSide.none,
                ),
              );
            }
            if (stats.totalSexualActivityWithUnknown > 0) {
              pieSections.add(
                PieChartSectionData(
                  color: secondary,
                  value: stats.totalSexualActivityWithUnknown.toDouble(),
                  title: AppLocalizations.of(context)!.unknown,
                  titleStyle: Theme.of(context).textTheme.labelMedium,
                  titlePositionPercentageOffset: 1.2,
                  radius: stats.totalSexualActivityWithUnknown /
                          stats.totalSexualActivity *
                          30 +
                      70,
                  borderSide: BorderSide.none,
                ),
              );
            }
          }

          if (pieSections.length > 1) {
            pieChartData = PieChartData(
              startDegreeOffset: 180,
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 1,
              centerSpaceRadius: 0,
              sections: pieSections,
            );

            StatisticType type;
            DateTime date = stats.lastSexualActivity!.date;
            if (chartType == 'safety') {
              type = StatisticType.safetyChart;
            } else if (chartType == 'sexDistribution') {
              type = StatisticType.sexDistributionChart;
            } else {
              type = StatisticType.timeDistributionChart;
            }

            list.add(
              DynamicStatisticData(
                type: type,
                date: date,
                data: pieChartData,
              ),
            );
          }
        }
      }
    }

    if (stats.mostPopularPartner != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.mostPopularPartner,
          date: stats.date,
          data: PartnerStatisticData(
            title: AppLocalizations.of(context)!.mostPopularPartner,
            partner: stats.mostPopularPartner!.partner,
            count: stats.mostPopularPartner!.count.toInt(),
          ),
        ),
      );
    }

    if (stats.mostPopularPlace != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.simple,
          date: stats.lastSexualActivity!.date,
          data: SimpleStatisticData(
            title: AppLocalizations.of(context)!.mostPopularPlace,
            description: stats.mostPopularPlace!.id,
            count: stats.mostPopularPlace!.count.toInt(),
            icon: Icons.place,
          ),
        ),
      );
    }
    if (stats.mostPopularEjaculationPlace != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.simple,
          date: stats.lastSexualActivity!.date,
          data: SimpleStatisticData(
            title: AppLocalizations.of(context)!.mostPopularEjaculationPlace,
            description: stats.mostPopularEjaculationPlace!.id,
            count: stats.mostPopularEjaculationPlace!.count.toInt(),
            icon: Icons.water_drop,
          ),
        ),
      );
    }
    if (stats.mostPopularPractice != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.simple,
          date: stats.lastSexualActivity!.date,
          data: SimpleStatisticData(
            title: AppLocalizations.of(context)!.mostPopularPractice,
            description: stats.mostPopularPractice!.id,
            count: stats.mostPopularPractice!.count.toInt(),
            icon: Icons.check_circle,
          ),
        ),
      );
    }
    if (stats.mostPopularMood != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.simple,
          date: stats.lastSexualActivity!.date,
          data: SimpleStatisticData(
            title: AppLocalizations.of(context)!.mostPopularMood,
            description: stats.mostPopularMood!.id,
            count: stats.mostPopularMood!.count.toInt(),
            icon: Icons.emoji_emotions,
          ),
        ),
      );
    }

    if (stats.mostActiveWeekday != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.simple,
          date: DateTime(stats.date.year, stats.date.month, stats.date.day),
          data: SimpleStatisticData(
            title: AppLocalizations.of(context)!.mostActiveWeekday,
            description: stats.mostActiveWeekday!.id,
            count: stats.mostActiveWeekday!.count.toInt(),
            icon: Icons.calendar_today,
          ),
        ),
      );
    }
    list.add(
      DynamicStatisticData(
        type: StatisticType.simple,
        date: DateTime(stats.date.year, stats.date.month, stats.date.day),
        data: SimpleStatisticData(
          title: AppLocalizations.of(context)!.orgasmRatio,
          description:
              "${stats.orgasmRatio} (${stats.orgasmsGiven} / ${stats.orgasmsReceived})",
          icon: Icons.whatshot,
        ),
      ),
    );

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

  Stats generateStats() {
    debugPrint('generateStats');
    DateTime date = DateTime.now();
    Activity? lastSexualActivity;
    Activity? firstSexualActivity;
    int daysSinceLastSexualActivity = 0;
    Activity? lastMasturbation;
    Activity? firstMasturbation;
    int daysSinceLastMasturbation = 0;
    int daysSinceLastSexualStimulation = 0;
    int totalSexualActivity = 0;
    int totalSexualActivityWithMale = 0;
    int totalSexualActivityWithFemale = 0;
    int totalSexualActivityWithUnknown = 0;
    int totalMasturbation = 0;
    StatsCountPartner? mostPopularPartner;
    StatsCount? mostPopularPractice;
    StatsCount? mostPopularMood;
    StatsCount? mostPopularEjaculationPlace;
    StatsCount? mostPopularPlace;
    double safetyPercentSafe = 0;
    double safetyPercentUnsafe = 0;
    double safetyPercentPartlyUnsafe = 0;
    StatsCount? mostActiveYear;
    StatsCount? mostActiveMonth;
    StatsCount? mostActiveDay;
    StatsCount? mostActiveWeekday;
    StatsCount? mostActiveHour;
    double orgasmRatio = 0;
    double averageDuration = 0;
    int activityWithDuration = 0;
    int totalDuration = 0;

    Map<String, int> partners = {};
    Map<String, int> practices = {};
    Map<String, int> moods = {};
    Map<String, int> ejaculationPlaces = {};
    Map<String, int> places = {};
    Map<String, int> years = {};
    Map<String, int> months = {};
    Map<String, int> days = {};
    Map<String, int> weekdays = {};
    Map<String, int> hours = {};
    Map<String, int> timeDistribution = {};
    Map<String, StatsCountTimeData> weeklyStats = {};
    Map<String, StatsCountTimeData> monthlyStats = {};
    Map<String, StatsCountTimeData> yearlyStats = {};
    Map<String, StatsCountTimeData> globalStats = {};
    Map<String, StatsCount> timeDistributionStats = {};
    int orgasmsReceived = 0;
    int orgasmsGiven = 0;
    num safetySafe = 0;
    num safetyUnsafe = 0;
    num safetyPartlyUnsafe = 0;
    List<String> weekdayNames = DateFormat.EEEE().dateSymbols.SHORTWEEKDAYS;
    List<String> monthNames = DateFormat.EEEE().dateSymbols.MONTHS;
    List<String> monthInitialNames = DateFormat.EEEE().dateSymbols.NARROWMONTHS;

    for (Activity activity in _activity) {
      if (activity.type == ActivityType.sexualIntercourse) {
        totalSexualActivity += 1;
        Partner? partner;
        if (activity.partner != null) {
          if (partners[activity.partner] == null) {
            partners[activity.partner!] = 1;
          } else {
            partners[activity.partner!] = partners[activity.partner!]! + 1;
          }
          partner = getPartnerById(activity.partner!);
          if (partner != null) {
            if (partner.sex == BiologicalSex.male) {
              totalSexualActivityWithMale += 1;
            } else {
              totalSexualActivityWithFemale += 1;
            }
          } else {
            totalSexualActivityWithUnknown += 1;
          }
        } else {
          totalSexualActivityWithUnknown += 1;
        }
        if (lastSexualActivity == null ||
            lastSexualActivity.date.compareTo(activity.date) == -1) {
          lastSexualActivity = activity;
        }
        if (firstSexualActivity == null ||
            firstSexualActivity.date.compareTo(activity.date) == 1) {
          firstSexualActivity = activity;
        }
        if (activity.ejaculation != null) {
          if (ejaculationPlaces[
                  getEjaculationTranslation(activity.ejaculation)] ==
              null) {
            ejaculationPlaces[getEjaculationTranslation(activity.ejaculation)] =
                1;
          } else {
            ejaculationPlaces[getEjaculationTranslation(activity.ejaculation)] =
                ejaculationPlaces[
                        getEjaculationTranslation(activity.ejaculation)]! +
                    1;
          }
        }
        if (years[activity.date.year.toString()] == null) {
          years[activity.date.year.toString()] = 1;
        } else {
          years[activity.date.year.toString()] =
              years[activity.date.year.toString()]! + 1;
        }
        String monthName = monthNames[activity.date.month - 1].capitalize();
        if (months[monthName] == null) {
          months[monthName] = 1;
        } else {
          months[monthName] = months[monthName]! + 1;
        }
        if (days[activity.date.day.toString()] == null) {
          days[activity.date.day.toString()] = 1;
        } else {
          days[activity.date.day.toString()] =
              days[activity.date.day.toString()]! + 1;
        }
        String weekdayName =
            weekdayNames[activity.date.weekday == 7 ? 0 : activity.date.weekday]
                .capitalize();
        if (weekdays[weekdayName] == null) {
          weekdays[weekdayName] = 1;
        } else {
          weekdays[weekdayName] = weekdays[weekdayName]! + 1;
        }
        if (hours[activity.date.hour.toString()] == null) {
          hours[activity.date.hour.toString()] = 1;
        } else {
          hours[activity.date.hour.toString()] =
              hours[activity.date.hour.toString()]! + 1;
        }
        if (timeDistribution.isEmpty) {
          timeDistribution['0'] = 0;
          timeDistribution['6'] = 0;
          timeDistribution['12'] = 0;
          timeDistribution['18'] = 0;
        }
        if (activity.date.hour >= 0 && activity.date.hour < 6) {
          timeDistribution['0'] = timeDistribution['0']! + 1;
        } else if (activity.date.hour >= 6 && activity.date.hour < 12) {
          timeDistribution['6'] = timeDistribution['6']! + 1;
        } else if (activity.date.hour >= 12 && activity.date.hour < 18) {
          timeDistribution['12'] = timeDistribution['12']! + 1;
        } else {
          timeDistribution['18'] = timeDistribution['18']! + 1;
        }

        if (activity.practices != null) {
          for (Practice practice in activity.practices!) {
            if (practices[getPracticeTranslation(practice)] == null) {
              practices[getPracticeTranslation(practice)] = 1;
            } else {
              practices[getPracticeTranslation(practice)] =
                  practices[getPracticeTranslation(practice)]! + 1;
            }
          }
        }

        if (activity.duration > 0) {
          totalDuration += activity.duration;
          activityWithDuration += 1;
        }
        orgasmsReceived += activity.orgasms;
        orgasmsGiven += activity.partnerOrgasms;

        ActivitySafety safety = calculateSafety(activity);
        if (safety == ActivitySafety.safe) {
          safetySafe += 1;
        } else if (safety == ActivitySafety.unsafe) {
          safetyUnsafe += 1;
        } else {
          safetyPartlyUnsafe += 1;
        }
      } else {
        totalMasturbation += 1;
        if (lastMasturbation == null ||
            lastMasturbation.date.compareTo(activity.date) == -1) {
          lastMasturbation = activity;
        }
        if (firstMasturbation == null ||
            firstMasturbation.date.compareTo(activity.date) == 1) {
          firstMasturbation = activity;
        }
      }

      if (activity.mood != null) {
        if (moods[getMoodTranslation(activity.mood)] == null) {
          moods[getMoodTranslation(activity.mood)] = 1;
        } else {
          moods[getMoodTranslation(activity.mood)] =
              moods[getMoodTranslation(activity.mood)]! + 1;
        }
      }
      if (activity.place != null) {
        if (places[getPlaceTranslation(activity.place)] == null) {
          places[getPlaceTranslation(activity.place)] = 1;
        } else {
          places[getPlaceTranslation(activity.place)] =
              places[getPlaceTranslation(activity.place)]! + 1;
        }
      }
    }

    if (lastSexualActivity != null) {
      daysSinceLastSexualActivity =
          (date.difference(lastSexualActivity.date).inHours / 24)
              .floor()
              .toInt();
    }
    if (lastMasturbation != null) {
      daysSinceLastMasturbation =
          (date.difference(lastMasturbation.date).inHours / 24).floor().toInt();
    }

    if (lastSexualActivity != null && lastMasturbation != null) {
      daysSinceLastSexualStimulation =
          lastSexualActivity.date.difference(lastMasturbation.date).inSeconds >
                  0
              ? daysSinceLastSexualActivity
              : daysSinceLastMasturbation;
    } else if (lastSexualActivity != null) {
      daysSinceLastSexualStimulation = daysSinceLastSexualActivity;
    } else if (lastMasturbation != null) {
      daysSinceLastSexualStimulation = daysSinceLastMasturbation;
    }

    if (orgasmsGiven > 0 || orgasmsReceived > 0) {
      orgasmRatio = double.parse(
        (orgasmsGiven / orgasmsReceived).toStringAsFixed(2),
      );
    }
    if (totalDuration > 0 && activityWithDuration > 0) {
      averageDuration = double.parse(
        (totalDuration / activityWithDuration).toStringAsFixed(1),
      );
    }

    safetyPercentSafe = double.parse(
      (safetySafe * 100 / totalSexualActivity).toStringAsFixed(1),
    );
    safetyPercentUnsafe = double.parse(
      (safetyUnsafe * 100 / totalSexualActivity).toStringAsFixed(1),
    );
    safetyPercentPartlyUnsafe = double.parse(
      (safetyPartlyUnsafe * 100 / totalSexualActivity).toStringAsFixed(1),
    );

    biggestCountReducer(MapEntry<String, int> a, MapEntry<String, int> b) {
      final aValue = a.value;
      final bValue = b.value;
      return aValue > bValue ? a : b;
    }

    if (partners.isNotEmpty) {
      String? mostPopularPartnerKey =
          partners.entries.reduce(biggestCountReducer).key as String?;
      if (mostPopularPartnerKey != null) {
        Partner? partner = getPartnerById(mostPopularPartnerKey);
        if (partner != null) {
          mostPopularPartner = StatsCountPartner(
              partner: partner, count: partners[mostPopularPartnerKey] as num);
        }
      }
    }
    if (places.isNotEmpty) {
      String? mostPopularPlaceKey =
          places.entries.reduce(biggestCountReducer).key as String?;
      if (mostPopularPlaceKey != null) {
        mostPopularPlace = StatsCount(
            id: mostPopularPlaceKey,
            count: places[mostPopularPlaceKey]!.toDouble());
      }
    }
    if (practices.isNotEmpty) {
      String? mostPopularPracticeKey =
          practices.entries.reduce(biggestCountReducer).key as String?;
      if (mostPopularPracticeKey != null) {
        mostPopularPractice = StatsCount(
            id: mostPopularPracticeKey,
            count: practices[mostPopularPracticeKey]!.toDouble());
      }
    }
    if (moods.isNotEmpty) {
      String? mostPopularMoodKey =
          moods.entries.reduce(biggestCountReducer).key as String?;
      if (mostPopularMoodKey != null) {
        mostPopularMood = StatsCount(
            id: mostPopularMoodKey,
            count: moods[mostPopularMoodKey]!.toDouble());
      }
    }
    if (ejaculationPlaces.isNotEmpty) {
      String? mostPopularEjaculationPlaceKey =
          ejaculationPlaces.entries.reduce(biggestCountReducer).key as String?;
      if (mostPopularEjaculationPlaceKey != null) {
        mostPopularEjaculationPlace = StatsCount(
            id: mostPopularEjaculationPlaceKey,
            count:
                ejaculationPlaces[mostPopularEjaculationPlaceKey]!.toDouble());
      }
    }
    if (years.isNotEmpty) {
      String? mostActiveYearKey =
          years.entries.reduce(biggestCountReducer).key as String?;
      if (mostActiveYearKey != null) {
        mostActiveYear = StatsCount(
            id: mostActiveYearKey, count: years[mostActiveYearKey]!.toDouble());
      }
    }
    if (months.isNotEmpty) {
      String? mostActiveMonthKey =
          months.entries.reduce(biggestCountReducer).key as String?;
      if (mostActiveMonthKey != null) {
        mostActiveMonth = StatsCount(
            id: mostActiveMonthKey,
            count: months[mostActiveMonthKey]!.toDouble());
      }
    }
    if (days.isNotEmpty) {
      String? mostActiveDayKey =
          days.entries.reduce(biggestCountReducer).key as String?;
      if (mostActiveDayKey != null) {
        mostActiveDay = StatsCount(
            id: mostActiveDayKey, count: days[mostActiveDayKey]!.toDouble());
      }
    }
    if (weekdays.isNotEmpty) {
      String? mostActiveWeekdayKey =
          weekdays.entries.reduce(biggestCountReducer).key as String?;
      if (mostActiveWeekdayKey != null) {
        mostActiveWeekday = StatsCount(
            id: mostActiveWeekdayKey,
            count: weekdays[mostActiveWeekdayKey]!.toDouble());
      }
    }
    if (hours.isNotEmpty) {
      String? mostActiveHourKey =
          hours.entries.reduce(biggestCountReducer).key as String?;
      if (mostActiveHourKey != null) {
        mostActiveHour = StatsCount(
            id: mostActiveHourKey, count: hours[mostActiveHourKey]!.toDouble());
      }
    }

    List<String> countTypes = ['week', 'day', 'month', 'year'];
    int length = 0;
    for (String countType in countTypes) {
      if (countType == 'week') {
        length = 6;
      } else if (countType == 'day') {
        length = 30;
      } else if (countType == 'month') {
        length = 11;
      } else if (countType == 'year') {
        length = 0;
        int firstYear = date.year;
        if (firstSexualActivity != null) {
          if (firstYear > firstSexualActivity.date.year) {
            firstYear = firstSexualActivity.date.year;
          }
        }
        if (firstMasturbation != null) {
          if (firstYear > firstMasturbation.date.year) {
            firstYear = firstMasturbation.date.year;
          }
        }
        length += (date.year - firstYear);
      }
      for (var i = length; i >= 0; i--) {
        DateTime currentDate = date;
        List<Activity> currentTimeData = [];
        if (countType == 'week') {
          currentDate = DateTime(
            date.year,
            date.month,
            date.day,
          ).add(Duration(days: -i));
          currentTimeData = _activity
              .where((element) =>
                  element.date.day == currentDate.day &&
                  element.date.month == currentDate.month &&
                  element.date.year == currentDate.year)
              .toList();
        } else if (countType == 'day') {
          currentDate = DateTime(
            date.year,
            date.month,
            date.day,
          ).add(Duration(days: -i));
          currentTimeData = _activity
              .where((element) =>
                  element.date.day == currentDate.day &&
                  element.date.month == currentDate.month &&
                  element.date.year == currentDate.year)
              .toList();
        } else if (countType == 'month') {
          currentDate = DateTime(
            date.year,
            date.month,
          ).add(Duration(days: -i * 30));
          currentTimeData = _activity
              .where((element) =>
                  element.date.month == currentDate.month &&
                  element.date.year == currentDate.year)
              .toList();
        } else if (countType == 'year') {
          currentDate = DateTime(
            date.year,
          ).add(Duration(days: -i * 365));
          currentTimeData = _activity
              .where((element) => element.date.year == currentDate.year)
              .toList();
        }

        List<Activity> filterKnown = currentTimeData
            .where((element) =>
                element.type == ActivityType.sexualIntercourse &&
                element.partner != null)
            .toList();
        int maleCount = 0;
        int femaleCount = 0;
        for (Activity activity in filterKnown) {
          Partner? partner = getPartnerById(activity.partner!);
          if (partner != null) {
            if (partner.sex == BiologicalSex.male) {
              maleCount += 1;
            } else {
              femaleCount += 1;
            }
          }
        }

        List<Activity> filterUnknown = currentTimeData
            .where((element) =>
                element.type == ActivityType.sexualIntercourse &&
                element.partner == null)
            .toList();

        List<Activity> filterMasturbation = currentTimeData
            .where((element) => element.type == ActivityType.masturbation)
            .toList();
        if (countType == 'week') {
          weeklyStats[(length - i).toString()] = StatsCountTimeData(
            id: weekdayNames.elementAt(
              currentDate.weekday == 7 ? 0 : currentDate.weekday,
            ),
            count: currentTimeData.length,
            male: maleCount,
            female: femaleCount,
            unknown: filterUnknown.length,
            masturbation: filterMasturbation.length,
          );
        } else if (countType == 'day') {
          monthlyStats[(length - i).toString()] = StatsCountTimeData(
            id: currentDate.day.toString(),
            count: currentTimeData.length,
            male: maleCount,
            female: femaleCount,
            unknown: filterUnknown.length,
            masturbation: filterMasturbation.length,
          );
        } else if (countType == 'month') {
          yearlyStats[(length - i).toString()] = StatsCountTimeData(
            id: monthInitialNames[currentDate.month - 1],
            count: currentTimeData.length,
            male: maleCount,
            female: femaleCount,
            unknown: filterUnknown.length,
            masturbation: filterMasturbation.length,
          );
        } else if (countType == 'year') {
          globalStats[(length - i).toString()] = StatsCountTimeData(
            id: currentDate.year.toString(),
            count: currentTimeData.length,
            male: maleCount,
            female: femaleCount,
            unknown: filterUnknown.length,
            masturbation: filterMasturbation.length,
          );
        }
      }
    }

    for (String key in timeDistribution.keys) {
      timeDistributionStats[key] = StatsCount(
        id: key,
        count: timeDistribution[key]!.toDouble(),
      );
    }

    stats = Stats(
      date: DateTime.now(),
      lastSexualActivity: lastSexualActivity,
      daysSinceLastSexualActivity: daysSinceLastSexualActivity,
      lastMasturbation: lastMasturbation,
      daysSinceLastMasturbation: daysSinceLastMasturbation,
      daysSinceLastSexualStimulation: daysSinceLastSexualStimulation,
      totalSexualActivity: totalSexualActivity,
      totalSexualActivityWithMale: totalSexualActivityWithMale,
      totalSexualActivityWithFemale: totalSexualActivityWithFemale,
      totalSexualActivityWithUnknown: totalSexualActivityWithUnknown,
      totalMasturbation: totalMasturbation,
      mostPopularPartner: mostPopularPartner,
      mostPopularPractice: mostPopularPractice,
      mostPopularMood: mostPopularMood,
      mostPopularEjaculationPlace: mostPopularEjaculationPlace,
      mostPopularPlace: mostPopularPlace,
      safetyPercentSafe: safetyPercentSafe,
      safetyPercentUnsafe: safetyPercentUnsafe,
      safetyPercentPartlyUnsafe: safetyPercentPartlyUnsafe,
      mostActiveYear: mostActiveYear,
      mostActiveMonth: mostActiveMonth,
      mostActiveDay: mostActiveDay,
      mostActiveWeekday: mostActiveWeekday,
      mostActiveHour: mostActiveHour,
      orgasmRatio: orgasmRatio,
      orgasmsGiven: orgasmsGiven,
      orgasmsReceived: orgasmsReceived,
      averageDuration: averageDuration,
      weeklyStats: weeklyStats,
      monthlyStats: monthlyStats,
      yearlyStats: yearlyStats,
      globalStats: globalStats,
      timeDistributionStats: timeDistributionStats,
    );
    // debugPrint(jsonEncode(stats));
    return stats;
  }

  void updateWidgets() {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        HomeWidget.setAppGroupId('group.LoveLust');
      }

      try {
        if (stats.lastSexualActivity != null ||
            stats.lastMasturbation != null) {
          Partner? partner;
          String safety = "PARTIALLY_UNSAFE";
          if (stats.lastSexualActivity != null) {
            if (stats.lastSexualActivity!.partner != null) {
              partner = getPartnerById(stats.lastSexualActivity!.partner!);
            }

            switch (calculateSafety(stats.lastSexualActivity!)) {
              case ActivitySafety.safe:
                safety = "SAFE";
                break;
              case ActivitySafety.unsafe:
                safety = "UNSAFE";
                break;
              default:
                safety = "PARTIALLY_UNSAFE";
            }
          }

          ActivityWidgetData widgetData = ActivityWidgetData(
            soloActivity: stats.lastMasturbation,
            sexualActivity: stats.lastSexualActivity,
            partner: partner,
            safety: safety,
            moodEmoji: stats.lastSexualActivity != null
                ? getMoodEmoji(stats.lastSexualActivity!.mood)
                : null,
            privacyMode: privacyMode,
          );

          HomeWidget.saveWidgetData<String>(
            'lastActivity',
            jsonEncode(widgetData),
          ).then((value) {
            HomeWidget.updateWidget(
              iOSName: "LastActivity",
              androidName: 'LastActivityWidgetReceiver',
              qualifiedAndroidName:
                  'works.end.LoveLust.glance.LastActivityWidgetReceiver',
            ).then(
              (value) => debugPrint("update LastActivity widget"),
            );
            HomeWidget.updateWidget(
              iOSName: "DaysSince",
              androidName: 'DaysSinceWidgetReceiver',
              qualifiedAndroidName:
                  'works.end.LoveLust.glance.DaysSinceWidgetReceiver',
            ).then(
              (value) => debugPrint("update DaysSince widget"),
            );
          });
        }
      } catch (e) {
        HomeWidget.saveWidgetData(
          'lastActivity',
          null,
        ).then((value) {
          HomeWidget.updateWidget(
            iOSName: "LastActivity",
            androidName: 'LastActivityWidgetReceiver',
            qualifiedAndroidName:
                'works.end.LoveLust.glance.LastActivityWidgetReceiver',
          ).then(
            (value) => debugPrint("delete LastActivity widget"),
          );
          HomeWidget.updateWidget(
            iOSName: "DaysSince",
            androidName: 'DaysSinceWidgetReceiver',
            qualifiedAndroidName:
                'works.end.LoveLust.glance.DaysSinceWidgetReceiver',
          ).then(
            (value) => debugPrint("delete DaysSince widget"),
          );
        });
      }
    }
  }

  void launchedFromWidget(Uri? uri) {
    if (uri != null) {
      BuildContext context = _navigator.navigatorKey.currentContext!;
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('App started from HomeScreenWidget'),
          content: Text('Here is the URI: $uri'),
        ),
      );
    }
  }

  @pragma("vm:entry-point")
  FutureOr<void> backgroundCallback(Uri? data) async {
    debugPrint("backgroundCallback $data");
  }

  void appLifecycleStateChanged(AppLifecycleState state) {
    debugPrint(state.name);
    appLifecycleState = state;
    if (state == AppLifecycleState.inactive) {
      if (requireAuth) {
        if (!isAuthenticating) {
          protected = true;
        }
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (!requireAuth || authorized) {
        protected = false;
      }
    }
    if (state == AppLifecycleState.paused) {
      if (requireAuth) {
        authorized = false;
        _localAuth.authenticationFailed = false;
      }
    }
    updateWidgets();
  }

  bool get isLoggedIn {
    return accessToken != null;
  }

  void signOut() {
    debugPrint('signOut');
    accessToken = null;
    refreshToken = null;
  }

  void clearPersonalData() {
    debugPrint('clearPersonalData');
    theme = 'system';
    colorScheme = null;
    accessToken = null;
    refreshToken = null;
    activity = [];
    partners = [];
    reload();
  }

  void clearData() async {
    debugPrint('clearData');
    await _storage.clear();
    reload();
  }

  Widget privacyRedactedText(String text, {TextStyle? style}) {
    return privacyMode
        ? Text(semiObscureText(text), style: style)
        : Text(text, style: style);
  }

  Widget inappropriateText(
    String text, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return sensitiveMode
        ? Text(semiObscureText(text), style: style)
        : Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          );
  }

  Widget blurText(String text, {TextStyle? style}) {
    Text widget = Text(text, style: style);
    double blurRadius = style != null ? style.fontSize! / 4 : 5;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: Container(child: widget),
    );
  }

  String semiObscureText(String text) {
    String semiObscureText = "";
    if (text.length >= 3) {
      semiObscureText += text[0];
      semiObscureText += "#" * (text.length - 2);
      semiObscureText += text[text.length - 1];
    } else {
      semiObscureText += "#" * (text.length);
    }
    return semiObscureText;
  }

  String obscureText(String text) {
    return text.replaceAll(RegExp(r"."), "#");
  }

  ActivitySafety calculateSafety(Activity activity) {
    List<Contraceptive> safe = [
      Contraceptive.condom,
      Contraceptive.internalCondom,
      Contraceptive.outercourse,
    ];
    List<Contraceptive?> unsafe = [
      null,
      Contraceptive.pullOut,
      Contraceptive.unsafeContraceptive
    ];

    if (safe.contains(activity.birthControl) ||
        safe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.safe;
    }

    if (unsafe.contains(activity.birthControl) &&
        unsafe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.unsafe;
    }

    return ActivitySafety.partiallyUnsafe;
  }

  bool isProtectionUsed(Activity activity) {
    if (calculateSafety(activity) == ActivitySafety.unsafe) {
      return false;
    }
    return true;
  }

  Activity? getActivityById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return _activity.firstWhere((element) => element.id == id);
  }

  List<Activity> getActivityByPartner(String? id) {
    return _activity.where((element) => element.partner == id).toList();
  }

  Partner? getPartnerById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return _partners.firstWhere((element) => element.id == id);
  }

  static Contraceptive? getContraceptiveByValue(String? value) {
    if (value == 'CERVICAL_CAP') {
      return Contraceptive.cervicalCap;
    } else if (value == 'CONDOM') {
      return Contraceptive.condom;
    } else if (value == 'DIAPHRAGM') {
      return Contraceptive.diaphragm;
    } else if (value == 'IMPLANT') {
      return Contraceptive.contraceptiveImplant;
    } else if (value == 'INFERTILITY') {
      return Contraceptive.infertility;
    } else if (value == 'INTERNAL_CONDOM') {
      return Contraceptive.internalCondom;
    } else if (value == 'IUD') {
      return Contraceptive.intrauterineDevice;
    } else if (value == 'OUTERCOURSE') {
      return Contraceptive.outercourse;
    } else if (value == 'PATCH') {
      return Contraceptive.contraceptivePatch;
    } else if (value == 'PILL') {
      return Contraceptive.pill;
    } else if (value == 'PULL_OUT') {
      return Contraceptive.pullOut;
    } else if (value == 'SHOT') {
      return Contraceptive.contraceptiveShot;
    } else if (value == 'SPONGE') {
      return Contraceptive.sponge;
    } else if (value == 'TUBAL_LIGATION') {
      return Contraceptive.tubalLigation;
    } else if (value == 'UNSAFE_BIRTH_CONTROL') {
      return Contraceptive.unsafeContraceptive;
    } else if (value == 'UNSAFE_CONTRACEPTIVE') {
      return Contraceptive.unsafeContraceptive;
    } else if (value == 'VAGINAL_RING') {
      return Contraceptive.vaginalRing;
    } else if (value == 'VASECTOMY') {
      return Contraceptive.vasectomy;
    } else if (value == 'ANAL') {
      return Contraceptive.anal;
    }
    return null;
  }

  static String? setValueByContraceptive(Contraceptive? value) {
    if (value == Contraceptive.cervicalCap) {
      return 'CERVICAL_CAP';
    } else if (value == Contraceptive.condom) {
      return 'CONDOM';
    } else if (value == Contraceptive.diaphragm) {
      return 'DIAPHRAGM';
    } else if (value == Contraceptive.contraceptiveImplant) {
      return 'IMPLANT';
    } else if (value == Contraceptive.infertility) {
      return 'INFERTILITY';
    } else if (value == Contraceptive.internalCondom) {
      return 'INTERNAL_CONDOM';
    } else if (value == Contraceptive.intrauterineDevice) {
      return 'IUD';
    } else if (value == Contraceptive.outercourse) {
      return 'OUTERCOURSE';
    } else if (value == Contraceptive.contraceptivePatch) {
      return 'PATCH';
    } else if (value == Contraceptive.pill) {
      return 'PILL';
    } else if (value == Contraceptive.pullOut) {
      return 'PULL_OUT';
    } else if (value == Contraceptive.contraceptiveShot) {
      return 'SHOT';
    } else if (value == Contraceptive.sponge) {
      return 'SPONGE';
    } else if (value == Contraceptive.tubalLigation) {
      return 'TUBAL_LIGATION';
    } else if (value == Contraceptive.unsafeContraceptive) {
      return 'UNSAFE_CONTRACEPTIVE';
    } else if (value == Contraceptive.vaginalRing) {
      return 'VAGINAL_RING';
    } else if (value == Contraceptive.vasectomy) {
      return 'VASECTOMY';
    } else if (value == Contraceptive.anal) {
      return 'ANAL';
    }
    return null;
  }

  static Initiator? getInitiatorByValue(String? value) {
    if (value == 'ME') {
      return Initiator.me;
    } else if (value == 'PARTNER') {
      return Initiator.partner;
    } else if (value == 'BOTH') {
      return Initiator.both;
    } else if (value == 'OTHER') {
      return Initiator.other;
    }
    return null;
  }

  static String? setValueByInitiator(Initiator? value) {
    if (value == Initiator.me) {
      return 'ME';
    } else if (value == Initiator.partner) {
      return 'PARTNER';
    } else if (value == Initiator.both) {
      return 'BOTH';
    } else if (value == Initiator.other) {
      return 'OTHER';
    }
    return null;
  }

  static Place? getPlaceByValue(String? value) {
    if (value == 'BACKYARD') {
      return Place.backyard;
    } else if (value == 'BAR') {
      return Place.bar;
    } else if (value == 'BATHROOM') {
      return Place.bathroom;
    } else if (value == 'BEACH') {
      return Place.beach;
    } else if (value == 'BEDROOM') {
      return Place.bedroom;
    } else if (value == 'CAR') {
      return Place.car;
    } else if (value == 'CHAIR') {
      return Place.chair;
    } else if (value == 'CINEMA') {
      return Place.cinema;
    } else if (value == 'ELEVATOR') {
      return Place.elevator;
    } else if (value == 'FOREST') {
      return Place.forest;
    } else if (value == 'GARAGE') {
      return Place.garage;
    } else if (value == 'HOME') {
      return Place.home;
    } else if (value == 'HOTEL') {
      return Place.hotel;
    } else if (value == 'JACUZZI') {
      return Place.jacuzzi;
    } else if (value == 'KITCHEN') {
      return Place.kitchen;
    } else if (value == 'LIVING_ROOM') {
      return Place.livingRoom;
    } else if (value == 'MUSEUM') {
      return Place.museum;
    } else if (value == 'OTHER') {
      return Place.other;
    } else if (value == 'PARTY') {
      return Place.party;
    } else if (value == 'PLANE') {
      return Place.plane;
    } else if (value == 'POOL') {
      return Place.pool;
    } else if (value == 'PUBLIC') {
      return Place.public;
    } else if (value == 'RESTROOM') {
      return Place.restroom;
    } else if (value == 'ROOF') {
      return Place.roof;
    } else if (value == 'SCHOOL') {
      return Place.school;
    } else if (value == 'SHIP') {
      return Place.ship;
    } else if (value == 'SHOWER') {
      return Place.shower;
    } else if (value == 'SOFA') {
      return Place.sofa;
    } else if (value == 'TABLE') {
      return Place.table;
    } else if (value == 'THEATRE') {
      return Place.theatre;
    } else if (value == 'TRAIN') {
      return Place.train;
    } else if (value == 'WORK') {
      return Place.work;
    }
    return null;
  }

  static String? setValueByPlace(Place? value) {
    if (value == Place.backyard) {
      return 'BACKYARD';
    } else if (value == Place.bar) {
      return 'BAR';
    } else if (value == Place.bathroom) {
      return 'BATHROOM';
    } else if (value == Place.beach) {
      return 'BEACH';
    } else if (value == Place.bedroom) {
      return 'BEDROOM';
    } else if (value == Place.car) {
      return 'CAR';
    } else if (value == Place.chair) {
      return 'CHAIR';
    } else if (value == Place.cinema) {
      return 'CINEMA';
    } else if (value == Place.elevator) {
      return 'ELEVATOR';
    } else if (value == Place.forest) {
      return 'FOREST';
    } else if (value == Place.garage) {
      return 'GARAGE';
    } else if (value == Place.home) {
      return 'HOME';
    } else if (value == Place.hotel) {
      return 'HOTEL';
    } else if (value == Place.jacuzzi) {
      return 'JACUZZI';
    } else if (value == Place.kitchen) {
      return 'KITCHEN';
    } else if (value == Place.livingRoom) {
      return 'LIVING_ROOM';
    } else if (value == Place.museum) {
      return 'MUSEUM';
    } else if (value == Place.other) {
      return 'OTHER';
    } else if (value == Place.party) {
      return 'PARTY';
    } else if (value == Place.plane) {
      return 'PLANE';
    } else if (value == Place.pool) {
      return 'POOL';
    } else if (value == Place.public) {
      return 'PUBLIC';
    } else if (value == Place.restroom) {
      return 'RESTROOM';
    } else if (value == Place.roof) {
      return 'ROOF';
    } else if (value == Place.school) {
      return 'SCHOOL';
    } else if (value == Place.ship) {
      return 'SHIP';
    } else if (value == Place.shower) {
      return 'SHOWER';
    } else if (value == Place.sofa) {
      return 'SOFA';
    } else if (value == Place.table) {
      return 'TABLE';
    } else if (value == Place.theatre) {
      return 'THEATRE';
    } else if (value == Place.train) {
      return 'TRAIN';
    } else if (value == Place.work) {
      return 'WORK';
    }
    return null;
  }

  static ActivityType? getActivityTypeByValue(String? value) {
    if (value == 'MASTURBATION') {
      return ActivityType.masturbation;
    } else if (value == 'SEXUAL_INTERCOURSE') {
      return ActivityType.sexualIntercourse;
    }
    return null;
  }

  static String? setValueByActivityType(ActivityType? value) {
    if (value == ActivityType.masturbation) {
      return 'MASTURBATION';
    } else if (value == ActivityType.sexualIntercourse) {
      return 'SEXUAL_INTERCOURSE';
    }
    return null;
  }

  static BiologicalSex getBiologicalSexByValue(String value) {
    if (value == 'F') {
      return BiologicalSex.female;
    }
    return BiologicalSex.male;
  }

  static String setValueByBiologicalSex(BiologicalSex value) {
    if (value == BiologicalSex.female) {
      return 'F';
    } else if (value == BiologicalSex.male) {
      return 'M';
    }
    return 'NB';
  }

  static Gender getGenderByValue(String value) {
    if (value == 'F') {
      return Gender.female;
    } else if (value == 'M') {
      return Gender.male;
    }
    return Gender.nonBinary;
  }

  static String setValueByGender(Gender value) {
    if (value == Gender.female) {
      return 'F';
    } else if (value == Gender.male) {
      return 'M';
    }
    return 'NB';
  }

  static Practice? getPracticeByValue(String? value) {
    if (value == 'ANAL') {
      return Practice.anal;
    } else if (value == 'BDSM') {
      return Practice.bdsm;
    } else if (value == 'BONDAGE') {
      return Practice.bondage;
    } else if (value == 'CHOKING') {
      return Practice.choking;
    } else if (value == 'CUDDLING') {
      return Practice.cuddling;
    } else if (value == 'DOMINATION') {
      return Practice.domination;
    } else if (value == 'FINGERING') {
      return Practice.fingering;
    } else if (value == 'HANDJOB') {
      return Practice.handjob;
    } else if (value == 'MASTURBATION') {
      return Practice.masturbation;
    } else if (value == 'ORAL') {
      return Practice.oral;
    } else if (value == 'TOY') {
      return Practice.toy;
    } else if (value == 'VAGINAL') {
      return Practice.vaginal;
    } else if (value == 'ANILINGUS') {
      return Practice.anilingus;
    } else if (value == 'BLOWJOB') {
      return Practice.blowjob;
    } else if (value == 'CUNNILINGUS') {
      return Practice.cunnilingus;
    } else if (value == 'TITJOB') {
      return Practice.titjob;
    } else if (value == 'WHITE_KISS') {
      return Practice.whiteKiss;
    } else if (value == 'CREAMPIE') {
      return Practice.creampie;
    }
    return null;
  }

  static String? setValueByPractice(Practice? value) {
    if (value == Practice.anal) {
      return 'ANAL';
    } else if (value == Practice.bdsm) {
      return 'BDSM';
    } else if (value == Practice.bondage) {
      return 'BONDAGE';
    } else if (value == Practice.choking) {
      return 'CHOKING';
    } else if (value == Practice.cuddling) {
      return 'CUDDLING';
    } else if (value == Practice.domination) {
      return 'DOMINATION';
    } else if (value == Practice.fingering) {
      return 'FINGERING';
    } else if (value == Practice.handjob) {
      return 'HANDJOB';
    } else if (value == Practice.masturbation) {
      return 'MASTURBATION';
    } else if (value == Practice.oral) {
      return 'ORAL';
    } else if (value == Practice.toy) {
      return 'TOY';
    } else if (value == Practice.vaginal) {
      return 'VAGINAL';
    } else if (value == Practice.anilingus) {
      return 'ANILINGUS';
    } else if (value == Practice.blowjob) {
      return 'BLOWJOB';
    } else if (value == Practice.cunnilingus) {
      return 'CUNNILINGUS';
    } else if (value == Practice.titjob) {
      return 'TITJOB';
    } else if (value == Practice.whiteKiss) {
      return 'WHITE_KISS';
    } else if (value == Practice.creampie) {
      return 'CREAMPIE';
    }
    return null;
  }

  static Mood? getMoodByValue(String? value) {
    if (value == 'ADVENTUROUS') {
      return Mood.adventurous;
    } else if (value == 'ANGRY') {
      return Mood.angry;
    } else if (value == 'COMFORTABLE') {
      return Mood.comfortable;
    } else if (value == 'CRAZY') {
      return Mood.crazy;
    } else if (value == 'HORNY') {
      return Mood.horny;
    } else if (value == 'LAZY') {
      return Mood.lazy;
    } else if (value == 'PLAYFUL') {
      return Mood.playful;
    } else if (value == 'RELAXED') {
      return Mood.relaxed;
    } else if (value == 'SAFE') {
      return Mood.safe;
    } else if (value == 'SCARED') {
      return Mood.scared;
    } else if (value == 'SURPRISED') {
      return Mood.surprised;
    } else if (value == 'UNSAFE') {
      return Mood.unsafe;
    } else if (value == 'OTHER') {
      return Mood.other;
    }
    return null;
  }

  static String? setValueByMood(Mood? value) {
    if (value == Mood.adventurous) {
      return 'ADVENTUROUS';
    } else if (value == Mood.angry) {
      return 'ANGRY';
    } else if (value == Mood.comfortable) {
      return 'COMFORTABLE';
    } else if (value == Mood.crazy) {
      return 'CRAZY';
    } else if (value == Mood.horny) {
      return 'HORNY';
    } else if (value == Mood.lazy) {
      return 'LAZY';
    } else if (value == Mood.playful) {
      return 'PLAYFUL';
    } else if (value == Mood.relaxed) {
      return 'RELAXED';
    } else if (value == Mood.safe) {
      return 'SAFE';
    } else if (value == Mood.scared) {
      return 'SCARED';
    } else if (value == Mood.surprised) {
      return 'SURPRISED';
    } else if (value == Mood.unsafe) {
      return 'UNSAFE';
    } else if (value == Mood.other) {
      return 'OTHER';
    }
    return null;
  }

  static Ejaculation? getEjaculationByValue(String? value) {
    if (value == 'ASS') {
      return Ejaculation.ass;
    } else if (value == 'BACK') {
      return Ejaculation.back;
    } else if (value == 'BUTTOCKS') {
      return Ejaculation.buttocks;
    } else if (value == 'CHEST') {
      return Ejaculation.chest;
    } else if (value == 'FACE') {
      return Ejaculation.face;
    } else if (value == 'MOUCH') {
      return Ejaculation.mouth;
    } else if (value == 'VAGINA') {
      return Ejaculation.vagina;
    }
    return null;
  }

  static String? setValueByEjaculation(Ejaculation? value) {
    if (value == Ejaculation.ass) {
      return 'ASS';
    } else if (value == Ejaculation.back) {
      return 'BACK';
    } else if (value == Ejaculation.buttocks) {
      return 'BUTTOCKS';
    } else if (value == Ejaculation.chest) {
      return 'CHEST';
    } else if (value == Ejaculation.face) {
      return 'FACE';
    } else if (value == Ejaculation.mouth) {
      return 'MOUCH';
    } else if (value == Ejaculation.vagina) {
      return 'VAGINA';
    }
    return null;
  }

  static AppIcon? getAppIconByValue(String? value) {
    if (value == 'Beta') {
      return AppIcon.beta;
    } else if (value == 'Classic') {
      return AppIcon.classic;
    } else if (value == 'MonoBlack') {
      return AppIcon.monoBlack;
    } else if (value == 'MonoWhite') {
      return AppIcon.monoWhite;
    } else if (value == 'White') {
      return AppIcon.white;
    } else if (value == 'Blue') {
      return AppIcon.blue;
    } else if (value == 'Filled') {
      return AppIcon.filled;
    } else if (value == 'Filled2') {
      return AppIcon.filled2;
    } else if (value == 'FilledWhite') {
      return AppIcon.filledWhite;
    } else if (value == 'FilledWhite2') {
      return AppIcon.filledWhite2;
    } else if (value == 'Bold') {
      return AppIcon.bold;
    } else if (value == 'Glow') {
      return AppIcon.glow;
    } else if (value == 'Health') {
      return AppIcon.health;
    } else if (value == 'Health2') {
      return AppIcon.health2;
    } else if (value == 'Health3') {
      return AppIcon.health3;
    } else if (value == 'Health4') {
      return AppIcon.health4;
    } else if (value == 'Journal') {
      return AppIcon.journal;
    } else if (value == 'Journal2') {
      return AppIcon.journal2;
    } else if (value == 'Partners') {
      return AppIcon.partners;
    } else if (value == 'Neon') {
      return AppIcon.neon;
    } else if (value == 'Pink') {
      return AppIcon.pink;
    } else if (value == 'Pride') {
      return AppIcon.pride;
    } else if (value == 'PrideAce') {
      return AppIcon.prideAce;
    } else if (value == 'PrideBi') {
      return AppIcon.prideBi;
    } else if (value == 'PrideRainbow') {
      return AppIcon.prideRainbow;
    } else if (value == 'PrideRainbowLine') {
      return AppIcon.prideRainbowLine;
    } else if (value == 'PrideTrans') {
      return AppIcon.prideTrans;
    } else if (value == 'PrideRomania') {
      return AppIcon.prideRomania;
    } else if (value == 'Purple') {
      return AppIcon.purple;
    } else if (value == 'DeepPurple') {
      return AppIcon.deepPurple;
    } else if (value == 'Red') {
      return AppIcon.red;
    } else if (value == 'Orange') {
      return AppIcon.orange;
    } else if (value == 'Sexapill') {
      return AppIcon.sexapill;
    } else if (value == 'SexapillWhite') {
      return AppIcon.sexapillWhite;
    } else if (value == 'Teal') {
      return AppIcon.teal;
    } else if (value == 'White') {
      return AppIcon.white;
    } else if (value == 'Pastel') {
      return AppIcon.pastel;
    } else if (value == 'Pills') {
      return AppIcon.pills;
    } else if (value == 'Pills2') {
      return AppIcon.pills2;
    } else if (value == 'Pills3') {
      return AppIcon.pills3;
    } else if (value == 'Condom') {
      return AppIcon.condom;
    } else if (value == 'Fire') {
      return AppIcon.fire;
    } else if (value == 'Butt') {
      return AppIcon.butt;
    } else if (value == 'Genital') {
      return AppIcon.genital;
    } else if (value == 'Abstract') {
      return AppIcon.abstract;
    } else if (value == 'Paper') {
      return AppIcon.paper;
    } else if (value == 'Overflow') {
      return AppIcon.overflow;
    }
    return AppIcon.defaultAppIcon;
  }

  static String? setValueByAppIcon(AppIcon? value) {
    if (value == AppIcon.beta) {
      return 'Beta';
    } else if (value == AppIcon.classic) {
      return 'Classic';
    } else if (value == AppIcon.monoBlack) {
      return 'MonoBlack';
    } else if (value == AppIcon.monoWhite) {
      return 'MonoWhite';
    } else if (value == AppIcon.white) {
      return 'White';
    } else if (value == AppIcon.blue) {
      return 'Blue';
    } else if (value == AppIcon.filled) {
      return 'Filled';
    } else if (value == AppIcon.filled2) {
      return 'Filled2';
    } else if (value == AppIcon.filledWhite) {
      return 'FilledWhite';
    } else if (value == AppIcon.filledWhite2) {
      return 'FilledWhite2';
    } else if (value == AppIcon.bold) {
      return 'Bold';
    } else if (value == AppIcon.glow) {
      return 'Glow';
    } else if (value == AppIcon.health) {
      return 'Health';
    } else if (value == AppIcon.health2) {
      return 'Health2';
    } else if (value == AppIcon.health3) {
      return 'Health3';
    } else if (value == AppIcon.health4) {
      return 'Health4';
    } else if (value == AppIcon.journal) {
      return 'Journal';
    } else if (value == AppIcon.journal2) {
      return 'Journal2';
    } else if (value == AppIcon.partners) {
      return 'Partners';
    } else if (value == AppIcon.neon) {
      return 'Neon';
    } else if (value == AppIcon.pink) {
      return 'Pink';
    } else if (value == AppIcon.pride) {
      return 'Pride';
    } else if (value == AppIcon.prideAce) {
      return 'PrideAce';
    } else if (value == AppIcon.prideBi) {
      return 'PrideBi';
    } else if (value == AppIcon.prideRainbow) {
      return 'PrideRainbow';
    } else if (value == AppIcon.prideRainbowLine) {
      return 'PrideRainbowLine';
    } else if (value == AppIcon.prideTrans) {
      return 'PrideTrans';
    } else if (value == AppIcon.prideRomania) {
      return 'PrideRomania';
    } else if (value == AppIcon.purple) {
      return 'Purple';
    } else if (value == AppIcon.deepPurple) {
      return 'DeepPurple';
    } else if (value == AppIcon.red) {
      return 'Red';
    } else if (value == AppIcon.orange) {
      return 'Orange';
    } else if (value == AppIcon.sexapill) {
      return 'Sexapill';
    } else if (value == AppIcon.sexapillWhite) {
      return 'SexapillWhite';
    } else if (value == AppIcon.teal) {
      return 'Teal';
    } else if (value == AppIcon.white) {
      return 'White';
    } else if (value == AppIcon.pastel) {
      return 'Pastel';
    } else if (value == AppIcon.pills) {
      return 'Pills';
    } else if (value == AppIcon.pills2) {
      return 'Pills2';
    } else if (value == AppIcon.pills3) {
      return 'Pills3';
    } else if (value == AppIcon.condom) {
      return 'Condom';
    } else if (value == AppIcon.fire) {
      return 'Fire';
    } else if (value == AppIcon.butt) {
      return 'Butt';
    } else if (value == AppIcon.genital) {
      return 'Genital';
    } else if (value == AppIcon.abstract) {
      return 'Abstract';
    } else if (value == AppIcon.paper) {
      return 'Paper';
    } else if (value == AppIcon.overflow) {
      return 'Overflow';
    }
    return null;
  }

  static AppColorScheme? getAppColorSchemeByValue(String? value) {
    if (value == 'dynamic') {
      return AppColorScheme.dynamic;
    } else if (value == 'black') {
      return AppColorScheme.black;
    } else if (value == 'blue') {
      return AppColorScheme.blue;
    } else if (value == 'love') {
      return AppColorScheme.pink;
    } else if (value == 'lust') {
      return AppColorScheme.purple;
    } else if (value == 'lipstick') {
      return AppColorScheme.red;
    } else if (value == 'shimapan') {
      return AppColorScheme.teal;
    }
    return AppColorScheme.defaultAppColorScheme;
  }

  static String? setValueByAppColorScheme(AppColorScheme? value) {
    if (value == AppColorScheme.black) {
      return 'black';
    } else if (value == AppColorScheme.blue) {
      return 'blue';
    } else if (value == AppColorScheme.dynamic) {
      return 'dynamic';
    } else if (value == AppColorScheme.pink) {
      return 'love';
    } else if (value == AppColorScheme.purple) {
      return 'lust';
    } else if (value == AppColorScheme.red) {
      return 'lipstick';
    } else if (value == AppColorScheme.teal) {
      return 'shimapan';
    }
    return null;
  }

  static String getContraceptiveTranslation(Contraceptive? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Contraceptive.cervicalCap) {
      return AppLocalizations.of(context)!.cervicalCap;
    } else if (value == Contraceptive.condom) {
      return AppLocalizations.of(context)!.condom;
    } else if (value == Contraceptive.contraceptiveImplant) {
      return AppLocalizations.of(context)!.contraceptiveImplant;
    } else if (value == Contraceptive.contraceptivePatch) {
      return AppLocalizations.of(context)!.contraceptivePatch;
    } else if (value == Contraceptive.contraceptiveShot) {
      return AppLocalizations.of(context)!.contraceptiveShot;
    } else if (value == Contraceptive.diaphragm) {
      return AppLocalizations.of(context)!.diaphragm;
    } else if (value == Contraceptive.infertility) {
      return AppLocalizations.of(context)!.infertility;
    } else if (value == Contraceptive.internalCondom) {
      return AppLocalizations.of(context)!.internalCondom;
    } else if (value == Contraceptive.intrauterineDevice) {
      return AppLocalizations.of(context)!.intrauterineDevice;
    } else if (value == Contraceptive.outercourse) {
      return AppLocalizations.of(context)!.outercourse;
    } else if (value == Contraceptive.pill) {
      return AppLocalizations.of(context)!.pill;
    } else if (value == Contraceptive.pullOut) {
      return AppLocalizations.of(context)!.pullOut;
    } else if (value == Contraceptive.sponge) {
      return AppLocalizations.of(context)!.sponge;
    } else if (value == Contraceptive.tubalLigation) {
      return AppLocalizations.of(context)!.tubalLigation;
    } else if (value == Contraceptive.unsafeContraceptive) {
      return AppLocalizations.of(context)!.unsafeContraceptive;
    } else if (value == Contraceptive.vaginalRing) {
      return AppLocalizations.of(context)!.vaginalRing;
    } else if (value == Contraceptive.vasectomy) {
      return AppLocalizations.of(context)!.vasectomy;
    } else if (value == Contraceptive.anal) {
      return AppLocalizations.of(context)!.anal;
    }
    return AppLocalizations.of(context)!.noBirthControl;
  }

  static String getPlaceTranslation(Place? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Place.backyard) {
      return AppLocalizations.of(context)!.backyard;
    } else if (value == Place.bar) {
      return AppLocalizations.of(context)!.bar;
    } else if (value == Place.bathroom) {
      return AppLocalizations.of(context)!.bathroom;
    } else if (value == Place.beach) {
      return AppLocalizations.of(context)!.beach;
    } else if (value == Place.bedroom) {
      return AppLocalizations.of(context)!.bedroom;
    } else if (value == Place.car) {
      return AppLocalizations.of(context)!.car;
    } else if (value == Place.chair) {
      return AppLocalizations.of(context)!.chair;
    } else if (value == Place.cinema) {
      return AppLocalizations.of(context)!.cinema;
    } else if (value == Place.elevator) {
      return AppLocalizations.of(context)!.elevator;
    } else if (value == Place.forest) {
      return AppLocalizations.of(context)!.forest;
    } else if (value == Place.garage) {
      return AppLocalizations.of(context)!.garage;
    } else if (value == Place.home) {
      return AppLocalizations.of(context)!.home;
    } else if (value == Place.hotel) {
      return AppLocalizations.of(context)!.hotel;
    } else if (value == Place.jacuzzi) {
      return AppLocalizations.of(context)!.jacuzzi;
    } else if (value == Place.kitchen) {
      return AppLocalizations.of(context)!.kitchen;
    } else if (value == Place.livingRoom) {
      return AppLocalizations.of(context)!.livingRoom;
    } else if (value == Place.museum) {
      return AppLocalizations.of(context)!.museum;
    } else if (value == Place.other) {
      return AppLocalizations.of(context)!.other;
    } else if (value == Place.party) {
      return AppLocalizations.of(context)!.party;
    } else if (value == Place.plane) {
      return AppLocalizations.of(context)!.plane;
    } else if (value == Place.pool) {
      return AppLocalizations.of(context)!.pool;
    } else if (value == Place.public) {
      return AppLocalizations.of(context)!.public;
    } else if (value == Place.restroom) {
      return AppLocalizations.of(context)!.restroom;
    } else if (value == Place.roof) {
      return AppLocalizations.of(context)!.roof;
    } else if (value == Place.school) {
      return AppLocalizations.of(context)!.school;
    } else if (value == Place.ship) {
      return AppLocalizations.of(context)!.ship;
    } else if (value == Place.shower) {
      return AppLocalizations.of(context)!.shower;
    } else if (value == Place.sofa) {
      return AppLocalizations.of(context)!.sofa;
    } else if (value == Place.table) {
      return AppLocalizations.of(context)!.table;
    } else if (value == Place.theatre) {
      return AppLocalizations.of(context)!.theatre;
    } else if (value == Place.train) {
      return AppLocalizations.of(context)!.train;
    } else if (value == Place.work) {
      return AppLocalizations.of(context)!.work;
    }
    return AppLocalizations.of(context)!.unknownPlace;
  }

  static String getInitiatorTranslation(Initiator? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Initiator.me) {
      return AppLocalizations.of(context)!.me;
    } else if (value == Initiator.partner) {
      return AppLocalizations.of(context)!.partner;
    } else if (value == Initiator.both) {
      return AppLocalizations.of(context)!.both;
    } else if (value == Initiator.other) {
      return AppLocalizations.of(context)!.other;
    }
    return AppLocalizations.of(context)!.noInitiator;
  }

  static String getEjaculationTranslation(Ejaculation? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Ejaculation.ass) {
      return AppLocalizations.of(context)!.ejaculationAss;
    } else if (value == Ejaculation.back) {
      return AppLocalizations.of(context)!.ejaculationBack;
    } else if (value == Ejaculation.buttocks) {
      return AppLocalizations.of(context)!.ejaculationButtocks;
    } else if (value == Ejaculation.chest) {
      return AppLocalizations.of(context)!.ejaculationChest;
    } else if (value == Ejaculation.face) {
      return AppLocalizations.of(context)!.ejaculationFace;
    } else if (value == Ejaculation.mouth) {
      return AppLocalizations.of(context)!.ejaculationMouth;
    } else if (value == Ejaculation.vagina) {
      return AppLocalizations.of(context)!.ejaculationVagina;
    }
    return AppLocalizations.of(context)!.noEjaculation;
  }

  static String getPracticeTranslation(Practice? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Practice.anal) {
      return AppLocalizations.of(context)!.anal;
    } else if (value == Practice.bdsm) {
      return AppLocalizations.of(context)!.bdsm;
    } else if (value == Practice.bondage) {
      return AppLocalizations.of(context)!.bondage;
    } else if (value == Practice.choking) {
      return AppLocalizations.of(context)!.choking;
    } else if (value == Practice.cuddling) {
      return AppLocalizations.of(context)!.cuddling;
    } else if (value == Practice.domination) {
      return AppLocalizations.of(context)!.domination;
    } else if (value == Practice.fingering) {
      return AppLocalizations.of(context)!.fingering;
    } else if (value == Practice.handjob) {
      return AppLocalizations.of(context)!.handjob;
    } else if (value == Practice.masturbation) {
      return AppLocalizations.of(context)!.masturbation;
    } else if (value == Practice.oral) {
      return AppLocalizations.of(context)!.oral;
    } else if (value == Practice.toy) {
      return AppLocalizations.of(context)!.toy;
    } else if (value == Practice.vaginal) {
      return AppLocalizations.of(context)!.vaginal;
    } else if (value == Practice.anilingus) {
      return AppLocalizations.of(context)!.anilingus;
    } else if (value == Practice.blowjob) {
      return AppLocalizations.of(context)!.blowjob;
    } else if (value == Practice.cunnilingus) {
      return AppLocalizations.of(context)!.cunnilingus;
    } else if (value == Practice.titjob) {
      return AppLocalizations.of(context)!.titjob;
    } else if (value == Practice.whiteKiss) {
      return AppLocalizations.of(context)!.whiteKiss;
    } else if (value == Practice.creampie) {
      return AppLocalizations.of(context)!.creampie;
    }
    return AppLocalizations.of(context)!.unknown;
  }

  static String getMoodTranslation(Mood? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Mood.adventurous) {
      return AppLocalizations.of(context)!.adventurous;
    } else if (value == Mood.angry) {
      return AppLocalizations.of(context)!.angry;
    } else if (value == Mood.comfortable) {
      return AppLocalizations.of(context)!.comfortable;
    } else if (value == Mood.crazy) {
      return AppLocalizations.of(context)!.crazy;
    } else if (value == Mood.horny) {
      return AppLocalizations.of(context)!.horny;
    } else if (value == Mood.lazy) {
      return AppLocalizations.of(context)!.lazy;
    } else if (value == Mood.playful) {
      return AppLocalizations.of(context)!.playful;
    } else if (value == Mood.relaxed) {
      return AppLocalizations.of(context)!.relaxed;
    } else if (value == Mood.safe) {
      return AppLocalizations.of(context)!.safeMood;
    } else if (value == Mood.scared) {
      return AppLocalizations.of(context)!.scared;
    } else if (value == Mood.surprised) {
      return AppLocalizations.of(context)!.surprised;
    } else if (value == Mood.unsafe) {
      return AppLocalizations.of(context)!.unsafeMood;
    } else if (value == Mood.other) {
      return AppLocalizations.of(context)!.other;
    }
    return AppLocalizations.of(context)!.noMood;
  }

  static String getMoodEmoji(Mood? value) {
    if (value == Mood.adventurous) {
      return '🤠';
    } else if (value == Mood.angry) {
      return '😡';
    } else if (value == Mood.comfortable) {
      return '😊';
    } else if (value == Mood.crazy) {
      return '🤪';
    } else if (value == Mood.horny) {
      return '🥵';
    } else if (value == Mood.lazy) {
      return '🥱';
    } else if (value == Mood.playful) {
      return '😏';
    } else if (value == Mood.relaxed) {
      return '😌';
    } else if (value == Mood.safe) {
      return '🥰';
    } else if (value == Mood.scared) {
      return '😨';
    } else if (value == Mood.surprised) {
      return '😮';
    } else if (value == Mood.unsafe) {
      return '🤔';
    } else if (value == Mood.other) {
      return '😶';
    }
    return '😐';
  }

  static String getAppIconTranslation(AppIcon? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == AppIcon.beta) {
      return AppLocalizations.of(context)!.beta;
    } else if (value == AppIcon.classic) {
      return AppLocalizations.of(context)!.classic;
    } else if (value == AppIcon.monoBlack) {
      return AppLocalizations.of(context)!.monoBlack;
    } else if (value == AppIcon.monoWhite) {
      return AppLocalizations.of(context)!.monoWhite;
    } else if (value == AppIcon.white) {
      return AppLocalizations.of(context)!.white;
    } else if (value == AppIcon.blue) {
      return AppLocalizations.of(context)!.blue;
    } else if (value == AppIcon.filled) {
      return AppLocalizations.of(context)!.filled;
    } else if (value == AppIcon.filled2) {
      return AppLocalizations.of(context)!.filled2;
    } else if (value == AppIcon.filledWhite) {
      return AppLocalizations.of(context)!.filledWhite;
    } else if (value == AppIcon.filledWhite2) {
      return AppLocalizations.of(context)!.filledWhite2;
    } else if (value == AppIcon.bold) {
      return AppLocalizations.of(context)!.bold;
    } else if (value == AppIcon.glow) {
      return AppLocalizations.of(context)!.glow;
    } else if (value == AppIcon.health) {
      return AppLocalizations.of(context)!.health;
    } else if (value == AppIcon.health2) {
      return AppLocalizations.of(context)!.health2;
    } else if (value == AppIcon.health3) {
      return AppLocalizations.of(context)!.health3;
    } else if (value == AppIcon.health4) {
      return AppLocalizations.of(context)!.health4;
    } else if (value == AppIcon.journal) {
      return AppLocalizations.of(context)!.journal;
    } else if (value == AppIcon.journal2) {
      return AppLocalizations.of(context)!.journal2;
    } else if (value == AppIcon.partners) {
      return AppLocalizations.of(context)!.partners;
    } else if (value == AppIcon.neon) {
      return AppLocalizations.of(context)!.neon;
    } else if (value == AppIcon.pink) {
      return AppLocalizations.of(context)!.love;
    } else if (value == AppIcon.pride) {
      return AppLocalizations.of(context)!.pride;
    } else if (value == AppIcon.prideAce) {
      return AppLocalizations.of(context)!.prideAce;
    } else if (value == AppIcon.prideBi) {
      return AppLocalizations.of(context)!.prideBi;
    } else if (value == AppIcon.prideRainbow) {
      return AppLocalizations.of(context)!.prideRainbow;
    } else if (value == AppIcon.prideRainbowLine) {
      return AppLocalizations.of(context)!.prideRainbowLine;
    } else if (value == AppIcon.prideTrans) {
      return AppLocalizations.of(context)!.prideTrans;
    } else if (value == AppIcon.prideRomania) {
      return AppLocalizations.of(context)!.prideRomania;
    } else if (value == AppIcon.purple) {
      return AppLocalizations.of(context)!.lust;
    } else if (value == AppIcon.deepPurple) {
      return AppLocalizations.of(context)!.deepPurple;
    } else if (value == AppIcon.red) {
      return AppLocalizations.of(context)!.lipstick;
    } else if (value == AppIcon.orange) {
      return AppLocalizations.of(context)!.orange;
    } else if (value == AppIcon.sexapill) {
      return AppLocalizations.of(context)!.sexapill;
    } else if (value == AppIcon.sexapillWhite) {
      return AppLocalizations.of(context)!.sexapillWhite;
    } else if (value == AppIcon.teal) {
      return AppLocalizations.of(context)!.shimapan;
    } else if (value == AppIcon.white) {
      return AppLocalizations.of(context)!.white;
    } else if (value == AppIcon.pastel) {
      return AppLocalizations.of(context)!.pastel;
    } else if (value == AppIcon.pills) {
      return AppLocalizations.of(context)!.pills;
    } else if (value == AppIcon.pills2) {
      return AppLocalizations.of(context)!.pills2;
    } else if (value == AppIcon.pills3) {
      return AppLocalizations.of(context)!.pills3;
    } else if (value == AppIcon.condom) {
      return AppLocalizations.of(context)!.condom;
    } else if (value == AppIcon.fire) {
      return AppLocalizations.of(context)!.fire;
    } else if (value == AppIcon.butt) {
      return AppLocalizations.of(context)!.butt;
    } else if (value == AppIcon.genital) {
      return AppLocalizations.of(context)!.genital;
    } else if (value == AppIcon.abstract) {
      return AppLocalizations.of(context)!.abstractIcon;
    } else if (value == AppIcon.paper) {
      return AppLocalizations.of(context)!.paper;
    } else if (value == AppIcon.overflow) {
      return AppLocalizations.of(context)!.overflow;
    }
    return AppLocalizations.of(context)!.defaultAppIcon;
  }

  static String getAppColorSchemeTranslation(AppColorScheme? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == AppColorScheme.black) {
      return AppLocalizations.of(context)!.black;
    } else if (value == AppColorScheme.dynamic) {
      return AppLocalizations.of(context)!.dynamicColorScheme;
    } else if (value == AppColorScheme.blue) {
      return AppLocalizations.of(context)!.blue;
    } else if (value == AppColorScheme.pink) {
      return AppLocalizations.of(context)!.love;
    } else if (value == AppColorScheme.purple) {
      return AppLocalizations.of(context)!.lust;
    } else if (value == AppColorScheme.red) {
      return AppLocalizations.of(context)!.lipstick;
    } else if (value == AppColorScheme.teal) {
      return AppLocalizations.of(context)!.shimapan;
    }
    return AppLocalizations.of(context)!.defaultColorScheme;
  }

  static String? emptyStringToNull(String? value) {
    if (value != null) {
      return value.isEmpty ? null : value;
    }
    return null;
  }

  String get theme {
    return _settings.theme;
  }

  set theme(String value) {
    _settings.theme = value;
    _storage.setSettings(_settings);
    notifyListeners();
    reload();
  }

  AppColorScheme? get colorScheme {
    return _settings.colorScheme;
  }

  set colorScheme(AppColorScheme? value) {
    _settings.colorScheme = value;
    _storage.setSettings(_settings);
    notifyListeners();
    reload();
  }

  String? get accessToken {
    return _settings.accessToken;
  }

  set accessToken(String? value) {
    _settings.accessToken = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  String? get refreshToken {
    return _settings.refreshToken;
  }

  set refreshToken(String? value) {
    _settings.refreshToken = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  List<Activity> get activity {
    return _activity;
  }

  set activity(List<Activity> value) {
    _activity = value;
    _storage.setActivity(value);
    generateStats();
    notifyListeners();
  }

  List<Partner> get partners {
    return _partners;
  }

  set partners(List<Partner> value) {
    _partners = value;
    _storage.setPartners(value);
    generateStats();
    notifyListeners();
  }

  bool get privacyMode {
    return _settings.privacyMode;
  }

  set privacyMode(bool value) {
    _settings.privacyMode = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get sensitiveMode {
    return _settings.sensitiveMode;
  }

  set sensitiveMode(bool value) {
    _settings.sensitiveMode = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get requireAuth {
    return _settings.requireAuth;
  }

  set requireAuth(bool value) {
    _settings.requireAuth = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get calendarView {
    return _settings.calendarView;
  }

  set calendarView(bool value) {
    _settings.calendarView = value;
    _settings.activityFilter = FilterEntryItem.all.name;
    _calendarSelectedDate = DateTime.now();
    _storage.setSettings(_settings);
    notifyListeners();
  }

  DateTime get calendarDate {
    return _calendarSelectedDate;
  }

  set calendarDate(DateTime value) {
    _calendarSelectedDate = value;
    notifyListeners();
  }

  bool get isToday {
    DateTime now = DateTime.now();
    return _calendarSelectedDate.year == now.year &&
        _calendarSelectedDate.month == now.month &&
        _calendarSelectedDate.day == now.day;
  }

  String? get activityFilter {
    return _settings.activityFilter;
  }

  set activityFilter(String? value) {
    _settings.activityFilter = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  AppIcon? get appIcon {
    return getAppIconByValue(_settings.appIcon);
  }

  set appIcon(AppIcon? value) {
    _settings.appIcon = setValueByAppIcon(value);
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get authorized {
    return _localAuth.authorized;
  }

  set authorized(bool value) {
    _localAuth.authorized = value;
    notifyListeners();
  }

  bool get isAuthenticating {
    return _localAuth.isAuthenticating;
  }

  set isAuthenticating(bool value) {
    _localAuth.isAuthenticating = value;
    notifyListeners();
  }

  List<Widget> get statistics {
    return _statistics;
  }

  set statistics(List<Widget> value) {
    _statistics = value;
    notifyListeners();
  }

  bool get protected {
    return _protected;
  }

  set protected(bool value) {
    _protected = value;
    notifyListeners();
  }

  bool get material {
    return _settings.material;
  }

  set material(bool value) {
    _settings.material = value;
    _storage.setSettings(_settings);
    notifyListeners();
    reload();
  }

  bool get trueBlack {
    return _settings.trueBlack;
  }

  set trueBlack(bool value) {
    _settings.trueBlack = value;
    _storage.setSettings(_settings);
    notifyListeners();
    reload();
  }
}
