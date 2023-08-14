import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyChartStatistic extends StatefulWidget {
  const WeeklyChartStatistic({super.key, required this.series});

  final List<XyDataSeries<WeeklyChartData, String>> series;

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
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.weeklyReport,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: SizedBox(
          height: MediaQuery.of(context).size.width /
              2.5, // height of the Container widget
          width: MediaQuery.of(context)
              .size
              .width, // width of the Container widget
          child: SfCartesianChart(
            legend: Legend(
              isVisible: widget.series.length > 1,
              position: LegendPosition.bottom,
              orientation: LegendItemOrientation.horizontal,
            ),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              interval: 1,
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              minorTicksPerInterval: 0,
            ),
            primaryYAxis: NumericAxis(
              isVisible: true,
              interval: 1,
              minorTicksPerInterval: 0,
            ),
            title: null,
            margin: const EdgeInsets.only(top: 8),
            series: widget.series,
          ),
        ),
      ),
    );
  }
}
