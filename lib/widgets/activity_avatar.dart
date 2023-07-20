import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
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
  final SharedService _common = getIt<SharedService>();
  Partner? partner;

  @override
  void initState() {
    super.initState();
    if (widget.partnerId != null) {
      partner = _common.getPartnerById(widget.partnerId!);
      setState(() {
        partner = partner;
      });
    }
  }

  Icon get icon {
    if (!widget.masturbation) {
      if (partner != null) {
        return Icon(
          partner!.gender == 'M' ? Icons.male : Icons.female,
          color: Theme.of(context).colorScheme.surface,
        );
      }
    } else {
      return Icon(
        Icons.back_hand,
        color: Theme.of(context).colorScheme.surface,
      );
    }

    return Icon(
      Icons.person,
      color: Theme.of(context).colorScheme.surface,
    );
  }

  Color get backgroundColor {
    Color red = Colors.red
      ..harmonizeWith(Theme.of(context).colorScheme.primary);
    Color blue = Colors.blue
      ..harmonizeWith(Theme.of(context).colorScheme.primary);
    if (!_common.monochrome) {
      if (!widget.masturbation) {
        if (partner != null) {
          return partner!.sex == 'M' ? blue : red;
        }
      } else {
        // return pink;
      }

      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: icon,
    );
  }
}
