import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
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

  List<Widget> get stats {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelTextTheme = Theme.of(context).textTheme.labelMedium;
    TextStyle? valueTextTheme = Theme.of(context).textTheme.bodySmall;

    List<Widget> list = [];
    if (_shared.stats.mostPopularPartner != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostPopularPartner}: ",
              style: labelTextTheme,
            ),
            _shared.privacyRedactedText(
              _shared.stats.mostPopularPartner!.partner.name,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostPopularPractice != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostPopularPractice}: ",
              style: labelTextTheme,
            ),
            _shared.inappropriateText(
              _shared.stats.mostPopularPractice!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostPopularMood != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostPopularMood}: ",
              style: labelTextTheme,
            ),
            _shared.inappropriateText(
              _shared.stats.mostPopularMood!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostPopularEjaculationPlace != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostPopularEjaculationPlace}: ",
              style: labelTextTheme,
            ),
            _shared.inappropriateText(
              _shared.stats.mostPopularEjaculationPlace!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostPopularPlace != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostPopularPlace}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.mostPopularPlace!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostActiveYear != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostActiveYear}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.mostActiveYear!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostActiveMonth != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostActiveMonth}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.mostActiveMonth!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostActiveHour != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostActiveHour}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.mostActiveHour!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.mostActiveWeekday != null) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.mostActiveWeekday}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.mostActiveWeekday!.id,
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.orgasmRatio > 0) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.orgasmRatio}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.orgasmRatio.toString(),
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }
    if (_shared.stats.averageDuration > 0) {
      list.add(
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.averageDuration}: ",
              style: labelTextTheme,
            ),
            Text(
              _shared.stats.averageDuration.toString(),
              style: valueTextTheme,
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.statistics,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ),
      ),
    );
  }
}
