import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class ActivityFilters extends StatefulWidget {
  const ActivityFilters({super.key});

  @override
  State<ActivityFilters> createState() => _ActivityFiltersState();
}

class _ActivityFiltersState extends State<ActivityFilters> {
  final SharedService _shared = getIt<SharedService>();

  void filterSelected(FilterEntryItem item) {
    setState(() {
      _shared.activityFilter = item.name;
    });
  }

  String filterName(FilterEntryItem item) {
    if (item == FilterEntryItem.all) {
      return AppLocalizations.of(context)!.all;
    } else if (item == FilterEntryItem.activity) {
      return AppLocalizations.of(context)!.sexualActivity;
    } else if (item == FilterEntryItem.solo) {
      return AppLocalizations.of(context)!.masturbation;
    }
    return '?';
  }

  List<FilterChip> get filters {
    return FilterEntryItem.values
        .map(
          (filter) => FilterChip(
            label: Text(filterName(filter)),
            selected: _shared.activityFilter == filter.name,
            showCheckmark: false,
            onSelected: (value) => filterSelected(filter),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: filters,
    );
  }
}
