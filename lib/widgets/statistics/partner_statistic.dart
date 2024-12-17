import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/screens/partners/partner_details.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';

class PartnerStatistic extends StatefulWidget {
  const PartnerStatistic({
    super.key,
    required this.data,
  });

  final PartnerStatisticData data;

  @override
  State<PartnerStatistic> createState() => _PartnerStatisticState();
}

class _PartnerStatisticState extends State<PartnerStatistic> {
  final SharedService _shared = getIt<SharedService>();

  void openPartner() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'PartnerDetails'),
        builder: (BuildContext context) => PartnerDetailsPage(
          partner: widget.data.partner,
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
      child: ListTile(
        onTap: openPartner,
        title: Text(
          widget.data.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _shared.privacyRedactedText(widget.data.partner.name),
            Text(
                " (${widget.data.count} ${AppLocalizations.of(context)!.countNumber(widget.data.count)})")
          ],
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
