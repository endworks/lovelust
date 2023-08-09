import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyChartStatistic extends StatefulWidget {
  const WeeklyChartStatistic({super.key, required this.series});

  final List<LineSeries<WeeklyChartData, String>> series;

  @override
  State<WeeklyChartStatistic> createState() => _WeeklyChartStatisticState();
}

class _WeeklyChartStatisticState extends State<WeeklyChartStatistic> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.width /
            2, // height of the Container widget
        width:
            MediaQuery.of(context).size.width, // width of the Container widget
        child: SfCartesianChart(
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            orientation: LegendItemOrientation.horizontal,
          ),
          primaryXAxis: CategoryAxis(
            minorTicksPerInterval: 1,
          ),
          title: ChartTitle(
            text: AppLocalizations.of(context)!.weeklyReport,
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          series: widget.series,
        ),
      ),
    );
  }
}
