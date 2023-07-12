import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/journal/activity_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/activity_avatar.dart';

class ActivityItemAlt extends StatefulWidget {
  const ActivityItemAlt({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityItemAlt> createState() => _ActivityItemAltState();
}

class _ActivityItemAltState extends State<ActivityItemAlt> {
  final SharedService _common = getIt<SharedService>();
  Partner? partner;
  bool solo = false;

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      partner = _common.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
    setState(() {
      solo = widget.activity.type == 'MASTURBATION';
    });
  }

  void openActivity() {
    debugPrint('tap activity');
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return ActivityDetailsPage(
        activity: widget.activity,
      );
    }));
  }

  Icon? safetyIcon() {
    if (widget.activity.type != 'MASTURBATION') {
      if (widget.activity.safety == 'safe') {
        return Icon(Icons.check_circle,
            color: Colors.green
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      } else if (widget.activity.safety == 'unsafe') {
        return Icon(Icons.error,
            color: Colors.red
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      } else {
        return Icon(Icons.help,
            color: Colors.orange
                .harmonizeWith(Theme.of(context).colorScheme.primary));
      }
    }
    return null;
  }

  Widget date() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        DateFormat('dd MMMM yyyy').format(widget.activity.date),
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget time() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        DateFormat('hh:mm').format(widget.activity.date),
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget place() {
    IconData icon = Icons.bed;

    switch (widget.activity.place) {
      case 'BEDROOM':
        icon = Icons.bed;
        break;
      case 'PUBLIC':
        icon = Icons.park;
        break;
      case 'SOFA':
        icon = Icons.weekend;
        break;
      case 'TABLE':
        icon = Icons.table_restaurant;
        break;
      default:
        icon = Icons.bed;
    }

    return Row(children: [
      Icon(
        icon,
        color: Theme.of(context).colorScheme.outline,
        size: 13,
      ),
      widget.activity.place != null
          ? Text(
              _common.getPlaceById(widget.activity.place!)!.name,
              style: secondaryTextStyle(),
            )
          : Text(
              'Unknown place',
              style: secondaryTextStyle(),
            )
    ]);
  }

  Widget protection() {
    if (solo) {
      return const Text('');
    }
    String text = 'No protection';
    if (widget.activity.birthControl == null ||
        widget.activity.birthControl == 'NO_BIRTH_CONTROL') {
      if (widget.activity.partnerBirthControl != null &&
          widget.activity.partnerBirthControl != 'NO_BIRTH_CONTROL') {
        text = _common
            .getBirthControlById(widget.activity.partnerBirthControl!)!
            .name;
      }
    } else if (widget.activity.partnerBirthControl == null ||
        widget.activity.partnerBirthControl == 'NO_BIRTH_CONTROL') {
      if (widget.activity.birthControl != null &&
          widget.activity.birthControl != 'NO_BIRTH_CONTROL') {
        text = _common.getBirthControlById(widget.activity.birthControl!)!.name;
      }
    } else {
      if (widget.activity.birthControl == widget.activity.partnerBirthControl) {
        text = _common.getBirthControlById(widget.activity.birthControl!)!.name;
      } else {
        text =
            '${_common.getBirthControlById(widget.activity.birthControl!)!.name} + ${_common.getBirthControlById(widget.activity.partnerBirthControl!)!.name}';
      }
    }

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(text, style: secondaryTextStyle()),
    );
  }

  Widget duration() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Text(
        '${widget.activity.duration} min.',
        style: secondaryTextStyle(),
      ),
    );
  }

  Widget partnerName() {
    return Text(
      partner != null ? partner!.name : '',
      style: secondaryTextStyle(),
    );
  }

  Widget activity() {
    String title;
    Color color = Theme.of(context).colorScheme.onSurface;
    if (solo) {
      title = 'Solo';
    } else {
      switch (widget.activity.safety) {
        case 'safe':
          title = 'Safe sex';
          if (!_common.monochrome) {
            color = Colors.green
                .harmonizeWith(Theme.of(context).colorScheme.primary);
          }
          break;
        case 'unsafe':
          title = 'Unsafe sex';
          if (!_common.monochrome) {
            color =
                Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
          }
          break;
        default:
          title = 'Partly unsafe sex';
          if (!_common.monochrome) {
            color = Colors.orange
                .harmonizeWith(Theme.of(context).colorScheme.primary);
          }
      }
    }
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  TextStyle secondaryTextStyle() {
    return const TextStyle(
      // color: Theme.of(context).colorScheme.outline,
      fontSize: 13,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: openActivity,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [place(), time(), protection()],
              ),
              activity(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [partnerName(), duration()],
              )
            ],
          ),
          ActivityAvatar(
            partnerId: widget.activity.partner,
            masturbation: solo,
          )
        ],
      ),
    );
  }
}
