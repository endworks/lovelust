import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  final CommonService _commonService = getIt<CommonService>();
  Partner? partner;

  @override
  void initState() {
    super.initState();
    if (widget.activity.partner != null) {
      partner = _commonService.getPartnerById(widget.activity.partner!);
      setState(() {
        partner = partner;
      });
    }
  }

  Text title() {
    if (widget.activity.type != 'MASTURBATION') {
      if (partner != null) {
        return Text(partner!.name);
      } else {
        return const Text('Unknown partner');
      }
    } else {
      return const Text('Solo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
