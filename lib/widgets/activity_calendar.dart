import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityCalendar extends StatefulWidget {
  const ActivityCalendar({super.key});

  @override
  State<ActivityCalendar> createState() => _ActivityCalendarState();
}

class _ActivityCalendarState extends State<ActivityCalendar> {
  final SharedService _shared = getIt<SharedService>();
  double radius = 12;

  List<Activity> _getActivityForDay(DateTime day) {
    return _shared.activity
        .where(
          (i) =>
              i.date.year == day.year &&
              i.date.month == day.month &&
              i.date.day == day.day,
        )
        .toList();
  }

  dotsMarkBuilder(BuildContext context, date, List<Activity> events) {
    if (events.isEmpty) {
      return SizedBox();
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(0),
        child: Container(
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: events[index].type == ActivityType.sexualIntercourse
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  iconsMarkBuilder(BuildContext context, date, List<Activity> events) {
    if (events.isNotEmpty) {
      if (events.length > 2) {
        return Stack(
          children: [
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      events.length.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
          ],
        );
      } else {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) => _getIconForEvent(
                    events[index],
                  ),
                ),
              ),
            )
          ],
        );
      }
    }
  }

  counterMarkBuilder(BuildContext context, date, List<Activity> events) {
    if (events.isNotEmpty) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    events.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )),
          ),
        ],
      );
    }
  }

  Widget _getIconForEvent(Activity activity) {
    IconData icon;
    Color color;
    Color textColor;
    if (activity.type == ActivityType.masturbation) {
      icon = Icons.back_hand;
      color = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      icon = Icons.person;
      color = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;

      if (activity.partner != null) {
        Partner partner = _shared.getPartnerById(activity.partner!)!;
        if (partner.gender == Gender.female) {
          icon = Icons.female;
        } else if (partner.gender == Gender.male) {
          icon = Icons.male;
        } else {
          icon = Icons.transgender;
        }
        if (partner.sex == BiologicalSex.female) {
          color = Colors.red
            ..harmonizeWith(Theme.of(context).colorScheme.primary);
          textColor = Theme.of(context).colorScheme.surface;
        } else if (partner.gender == Gender.male) {
          color = Colors.blue
            ..harmonizeWith(Theme.of(context).colorScheme.primary);
          textColor = Theme.of(context).colorScheme.surface;
        }
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            icon,
            color: textColor,
            size: 10,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.now(),
        focusedDay: _shared.calendarDate,
        headerVisible: true,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.all(0),
          titleTextStyle: Theme.of(context).textTheme.titleMedium!,
        ),
        daysOfWeekVisible: true,
        daysOfWeekHeight: 20,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
          weekendStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: CalendarFormat.month,
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          outsideDaysVisible: false,
          canMarkersOverflow: true,
          defaultTextStyle: Theme.of(context).textTheme.bodyLarge!,
          defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          selectedTextStyle: Theme.of(context).textTheme.bodyLarge!,
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          todayTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          cellMargin: EdgeInsets.all(2),
          weekendTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          disabledTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
              ),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_shared.calendarDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _shared.calendarDate = selectedDay;
          });
        },
        eventLoader: (day) {
          return _getActivityForDay(day);
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (BuildContext context, date, List<Activity> events) =>
              iconsMarkBuilder(context, date, events),
        ),
      ),
    );
  }
}
