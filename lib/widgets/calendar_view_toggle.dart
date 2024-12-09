import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class CalendarViewToggle extends StatefulWidget {
  const CalendarViewToggle({super.key});

  @override
  State<CalendarViewToggle> createState() => _CalendarViewToggleState();
}

class _CalendarViewToggleState extends State<CalendarViewToggle> {
  final SharedService _shared = getIt<SharedService>();

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const <ButtonSegment<bool>>[
        ButtonSegment<bool>(
            value: true,
            label: Text('Calendar'),
            icon: Icon(Icons.calendar_today)),
        ButtonSegment<bool>(
            value: false,
            label: Text('Timeline'),
            icon: Icon(Icons.calendar_view_day)),
      ],
      selected: {_shared.calendarView},
      onSelectionChanged: (Set<bool> newSelection) {
        setState(() {
          _shared.calendarView = newSelection.first;
        });
      },
    );
  }
}
