import 'package:flutter/material.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/widgets/statistics/days_without_sex_statistic.dart';
import 'package:lovelust/widgets/statistics/last_masturbation_statistic.dart';
import 'package:lovelust/widgets/statistics/last_relationship_statistic.dart';
import 'package:lovelust/widgets/statistics/overview.dart';
import 'package:lovelust/widgets/statistics/unsupported_statistic.dart';
import 'package:lovelust/widgets/statistics/weekly_chart_statistic.dart';

class DynamicStatistic<DataType> extends StatefulWidget {
  const DynamicStatistic({
    super.key,
    required this.type,
    required this.date,
    required this.data,
  });

  final StatisticType type;
  final DateTime date;
  final DataType data;

  @override
  State<DynamicStatistic> createState() => _DynamicStatisticState();
}

class _DynamicStatisticState extends State<DynamicStatistic> {
  Widget get statistic {
    if (widget.type == StatisticType.lastRelationship) {
      return LastRelationshipStatistic(activity: widget.data);
    } else if (widget.type == StatisticType.lastMasturbation) {
      return LastMasturbationStatistic(activity: widget.data);
    } else if (widget.type == StatisticType.daysWithoutSex) {
      return DaysWithoutSexStatistic(data: widget.data);
    } else if (widget.type == StatisticType.weeklyChart) {
      return WeeklyChartStatistic(series: widget.data);
    } else if (widget.type == StatisticType.overview) {
      return OverviewStatistic();
    }
    return const UnsupportedStatistic();
  }

  @override
  Widget build(BuildContext context) {
    return statistic;
  }
}
