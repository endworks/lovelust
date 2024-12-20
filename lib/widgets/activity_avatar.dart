import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class ActivityAvatar extends StatefulWidget {
  const ActivityAvatar(
      {super.key, required this.partnerId, this.masturbation = false});

  final String? partnerId;
  final bool masturbation;

  @override
  State<ActivityAvatar> createState() => _ActivityAvatarState();
}

class _ActivityAvatarState extends State<ActivityAvatar> {
  final SharedService _shared = getIt<SharedService>();

  Partner? get partner {
    if (widget.partnerId != null) {
      return _shared.getPartnerById(widget.partnerId!);
    }
    return null;
  }

  Icon get icon {
    if (!widget.masturbation) {
      if (partner != null) {
        if (partner!.gender == Gender.female) {
          return Icon(
            Icons.female,
            color: Theme.of(context).colorScheme.surface,
          );
        } else if (partner!.gender == Gender.male) {
          return Icon(
            Icons.male,
            color: Theme.of(context).colorScheme.surface,
          );
        } else {
          return Icon(
            Icons.transgender,
            color: Theme.of(context).colorScheme.surface,
          );
        }
      }
    } else {
      return Icon(
        Icons.back_hand,
        color: Theme.of(context).colorScheme.surface,
      );
    }

    return Icon(
      Icons.person,
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Color get backgroundColor {
    Color red = Colors.red
      ..harmonizeWith(Theme.of(context).colorScheme.primary);
    Color blue = Colors.blue
      ..harmonizeWith(Theme.of(context).colorScheme.primary);

    if (!widget.masturbation) {
      if (partner != null) {
        return partner!.sex == BiologicalSex.male ? blue : red;
      } else {
        return Theme.of(context).colorScheme.secondary;
      }
    }

    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: icon,
    );
  }
}
