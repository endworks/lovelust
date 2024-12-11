import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';

class BarChartStatistic extends StatefulWidget {
  const BarChartStatistic({
    super.key,
    required this.chartData,
    required this.type,
  });

  final BarChartData chartData;
  final StatisticType type;

  @override
  State<BarChartStatistic> createState() => _BarChartStatisticState();
}

class _BarChartStatisticState extends State<BarChartStatistic> {
  String get title {
    if (widget.type == StatisticType.weeklyChart) {
      return AppLocalizations.of(context)!.weeklyChart;
    } else if (widget.type == StatisticType.monthlyChart) {
      return AppLocalizations.of(context)!.monthlyChart;
    } else if (widget.type == StatisticType.yearlyChart) {
      return AppLocalizations.of(context)!.yearlyChart;
    } else {
      return AppLocalizations.of(context)!.globalChart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.width / 2,
            width: MediaQuery.of(context).size.width,
            child: BarChart(widget.chartData),
          ),
        ),
      ),
    );
  }
}
