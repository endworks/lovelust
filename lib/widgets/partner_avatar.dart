import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PartnerAvatar extends StatefulWidget {
  const PartnerAvatar({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerAvatar> createState() => _PartnerAvatarState();
}

class _PartnerAvatarState extends State<PartnerAvatar> {
  final SharedService _shared = getIt<SharedService>();

  Icon get icon {
    return Icon(
      widget.partner.gender == Gender.male ? Icons.male : Icons.female,
      color: Theme.of(context).colorScheme.surface,
      size: 108,
    );
  }

  Color get backgroundColor {
    Color red = Colors.red
      ..harmonizeWith(Theme.of(context).colorScheme.primary);
    Color blue = Colors.blue
      ..harmonizeWith(Theme.of(context).colorScheme.primary);
    return widget.partner.sex == BiologicalSex.male ? blue : red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            maxRadius: 108,
            backgroundColor: backgroundColor,
            child: icon,
          ),
          _shared.sensitiveText(
            widget.partner.name,
            style: Theme.of(context).textTheme.displayMedium,
          )
        ],
      ),
    );
  }
}
