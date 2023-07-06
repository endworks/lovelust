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
  final CommonService _commonService = getIt<CommonService>();
  Partner? partner;
  int alpha = Colors.black26.alpha;

  @override
  void initState() {
    super.initState();
    if (widget.partnerId != null) {
      partner = _commonService.getPartnerById(widget.partnerId!);
      setState(() {
        partner = partner;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Colors.blue.withAlpha(Colors.black26.alpha);
    if (!widget.masturbation) {
      if (partner != null) {
        return CircleAvatar(
          backgroundColor: partner!.sex == 'M'
              ? Colors.blue.withAlpha(alpha)
              : Colors.red.withAlpha(alpha),
          child: Icon(
            partner!.gender == 'M' ? Icons.male : Icons.female,
            color: partner!.sex == 'M' ? Colors.blue : Colors.red,
          ),
        );
      } else {
        return CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withAlpha(alpha),
          child: Icon(
            Icons.person_off,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } else {
      return CircleAvatar(
        backgroundColor: Colors.pink.withAlpha(alpha),
        child: const Icon(
          Icons.front_hand,
          color: Colors.pink,
        ),
      );
    }
  }
}
