import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';

class PieChartStatistic extends StatefulWidget {
  const PieChartStatistic({
    super.key,
    required this.chartData,
    required this.type,
  });

  final PieChartData chartData;
  final StatisticType type;

  @override
  State<PieChartStatistic> createState() => _PieChartStatisticState();
}

class _PieChartStatisticState extends State<PieChartStatistic> {
  String get title {
    if (widget.type == StatisticType.safetyChart) {
      return AppLocalizations.of(context)!.safetyChart;
    } else if (widget.type == StatisticType.sexDistributionChart) {
      return AppLocalizations.of(context)!.sexDistributionChart;
    } else {
      return AppLocalizations.of(context)!.timeDistributionChart;
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
            child: PieChart(widget.chartData),
          ),
        ),
      ),
    );
  }
}
