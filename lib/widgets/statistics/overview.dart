import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class OverviewStatistic extends StatefulWidget {
  const OverviewStatistic({super.key});

  @override
  State<OverviewStatistic> createState() => _OverviewStatisticState();
}

class _OverviewStatisticState extends State<OverviewStatistic> {
  final SharedService _shared = getIt<SharedService>();

  @override
  void initState() {
    super.initState();
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
          "Stats",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "lastSexualActivity: ${_shared.stats.lastSexualActivity?.id}",
            ),
            Text(
              "daysSinceLastSexualActivity: ${_shared.stats.daysSinceLastSexualActivity}",
            ),
            Text(
              "lastMasturbation: ${_shared.stats.lastMasturbation?.id}",
            ),
            Text(
              "daysSinceLastMasturbation: ${_shared.stats.daysSinceLastMasturbation}",
            ),
            Text(
              "daysSinceLastSexualStimulation: ${_shared.stats.daysSinceLastSexualStimulation}",
            ),
            Text(
              "totalSexualActivity: ${_shared.stats.totalSexualActivity}",
            ),
            Text(
              "totalSexualActivityWithMale: ${_shared.stats.totalSexualActivityWithMale}",
            ),
            Text(
              "totalSexualActivityWithFemale: ${_shared.stats.totalSexualActivityWithFemale}",
            ),
            Text(
              "totalSexualActivityWithUnknown: ${_shared.stats.totalSexualActivityWithUnknown}",
            ),
            Text(
              "totalMasturbation: ${_shared.stats.totalMasturbation}",
            ),
            Text(
              "mostPopularPartner: ${_shared.stats.mostPopularPartner?.partner.name}",
            ),
            Text(
              "mostPopularPractice: ${_shared.stats.mostPopularPractice?.id}",
            ),
            Text(
              "mostPopularMood: ${_shared.stats.mostPopularMood?.id}",
            ),
            Text(
              "mostPopularEjaculationPlace: ${_shared.stats.mostPopularEjaculationPlace?.id}",
            ),
            Text(
              "mostPopularPlace: ${_shared.stats.mostPopularPlace?.id}",
            ),
            Text(
              "safetyPercentSafe: ${_shared.stats.safetyPercentSafe}",
            ),
            Text(
              "safetyPercentUnsafe: ${_shared.stats.safetyPercentUnsafe}",
            ),
            Text(
              "safetyPercentPartlyUnsafe: ${_shared.stats.safetyPercentPartlyUnsafe}",
            ),
            Text(
              "mostActiveYear: ${_shared.stats.mostActiveYear?.id}",
            ),
            Text(
              "mostActiveMonth: ${_shared.stats.mostActiveMonth?.id}",
            ),
            Text(
              "mostActiveHour: ${_shared.stats.mostActiveHour?.id}",
            ),
            Text(
              "mostActiveWeekday: ${_shared.stats.mostActiveWeekday?.id}",
            ),
            Text(
              "mostActiveHour: ${_shared.stats.mostActiveHour?.id}",
            ),
            Text(
              "orgasmRatio: ${_shared.stats.orgasmRatio}",
            ),
            Text(
              "averageDuration: ${_shared.stats.averageDuration}",
            ),
          ],
        ),
      ),
    );
  }
}
