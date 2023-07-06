import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class ActivityAvatar extends StatefulWidget {
  const ActivityAvatar(
      {super.key, required this.partnerId, this.masturbation = false});

  final String? partnerId;
  final bool masturbation;

  @override
  State<ActivityAvatar> createState() => _ActivityAvatarState();
}

class _ActivityAvatarState extends State<ActivityAvatar> {
  final CommonService _common = getIt<CommonService>();
  Partner? partner;
  int alpha = Colors.black26.alpha;

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
    Color color = Theme.of(context).colorScheme.onPrimary;
    if (!widget.masturbation) {
      if (partner != null) {
        if (!_common.monochrome) {
          color = partner!.sex == 'M' ? Colors.blue : Colors.red;
        }
        return Icon(
          partner!.gender == 'M' ? Icons.male : Icons.female,
          color: color,
        );
      }
    } else {
      if (!_common.monochrome) {
        color = Colors.pink;
      }
      return Icon(
        Icons.front_hand,
        color: color,
      );
    }

    return Icon(
      Icons.person_off,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Color get backgroundColor {
    if (!_common.monochrome) {
      if (!widget.masturbation) {
        if (partner != null) {
          return partner!.sex == 'M'
              ? Colors.blue.withAlpha(alpha)
              : Colors.red.withAlpha(alpha);
        }
      } else {
        return Colors.pink.withAlpha(alpha);
      }

      return Theme.of(context).colorScheme.primary.withAlpha(alpha);
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
