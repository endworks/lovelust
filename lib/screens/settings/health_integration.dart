import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/health_service.dart';
import 'package:lovelust/widgets/generic_header.dart';

class HealthIntegrationPage extends StatefulWidget {
  const HealthIntegrationPage({super.key});

  @override
  State<HealthIntegrationPage> createState() => _HealthIntegrationPageState();
}

class _HealthIntegrationPageState extends State<HealthIntegrationPage> {
  final HealthService _health = getIt<HealthService>();
  bool hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _health.hasPermissions.then((value) {
      setState(() {
        hasPermissions = value;
      });
    });
  }

  List<Widget> get items {
    List<Widget> list = [
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.healthPermissions),
        value: hasPermissions,
        onChanged: (bool value) {
          if (!hasPermissions) {
            _health.requestPermissions();
          }
        },
        secondary: Icon(
          Icons.badge,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.healthImport),
        onTap: _health.importSexualActivity,
        leading: Icon(
          Icons.cloud_download,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.healthExport),
        onTap: _health.exportSexualActivity,
        leading: Icon(
          Icons.cloud_upload,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ];
    list.add(
      ListTile(
        title: Text(AppLocalizations.of(context)!.clearUnknownRecords),
        onTap: _health.clearUnknownRecords,
        leading: Icon(
          Icons.device_unknown,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    if (Platform.isAndroid) {
      list.add(
        ListTile(
          title: Text(AppLocalizations.of(context)!.healthOpen),
          onTap: _health.openHealthApp,
          leading: Icon(
            Icons.open_in_new,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
      list.add(
        ListTile(
          title: Text(AppLocalizations.of(context)!.healthInstall),
          onTap: _health.installHealthApp,
          leading: Icon(
            Icons.install_mobile,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          GenericHeader(
            title: Text(AppLocalizations.of(context)!.healthIntegration),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).padding.left,
              0,
              MediaQuery.of(context).padding.right,
              MediaQuery.of(context).padding.bottom,
            ),
            sliver: SliverList.list(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}
