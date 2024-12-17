import 'package:flutter/material.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/widgets/statistics/bar_chart_statistic.dart';
import 'package:lovelust/widgets/statistics/days_without_sex_statistic.dart';
import 'package:lovelust/widgets/statistics/last_masturbation_statistic.dart';
import 'package:lovelust/widgets/statistics/last_relationship_statistic.dart';
import 'package:lovelust/widgets/statistics/overview.dart';
import 'package:lovelust/widgets/statistics/partner_statistic.dart';
import 'package:lovelust/widgets/statistics/pie_chart_statistic.dart';
import 'package:lovelust/widgets/statistics/simple_statistic.dart';
import 'package:lovelust/widgets/statistics/unsupported_statistic.dart';

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
    if (widget.type == StatisticType.simple) {
      return SimpleStatistic(data: widget.data);
    } else if (widget.type == StatisticType.lastRelationship) {
      return LastRelationshipStatistic(activity: widget.data);
    } else if (widget.type == StatisticType.lastMasturbation) {
      return LastMasturbationStatistic(activity: widget.data);
    } else if (widget.type == StatisticType.daysWithoutSex) {
      return DaysWithoutSexStatistic(data: widget.data);
    } else if (widget.type == StatisticType.mostPopularPartner) {
      return PartnerStatistic(data: widget.data);
    } else if (widget.type == StatisticType.weeklyChart ||
        widget.type == StatisticType.monthlyChart ||
        widget.type == StatisticType.yearlyChart ||
        widget.type == StatisticType.globalChart) {
      return BarChartStatistic(chartData: widget.data, type: widget.type);
    } else if (widget.type == StatisticType.safetyChart ||
        widget.type == StatisticType.timeDistributionChart ||
        widget.type == StatisticType.sexDistributionChart) {
      return PieChartStatistic(chartData: widget.data, type: widget.type);
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
