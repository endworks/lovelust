import 'package:flutter/material.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService storage = getIt<StorageService>();
  final CommonService common = getIt<CommonService>();
  bool _isLoggedIn = false;
  int _activityCount = 0;
  int _partnersCount = 0;

  void _onSettingsClick() {
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return const SettingsPage();
    }));
  }

  @override
  void initState() {
    setState(() {
      _isLoggedIn = common.isLoggedIn();
      _activityCount = storage.activity.length;
      _partnersCount = storage.partners.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Text('Love',
              style: TextStyle(color: Color.fromARGB(255, 251, 35, 186))),
          Text('Lust',
              style: TextStyle(color: Color.fromARGB(255, 106, 47, 208))),
        ]),
        actions: [
          IconButton(
            icon: CircleAvatar(
                child: Icon(_isLoggedIn ? Icons.person : Icons.person_off)),
            onPressed: _onSettingsClick,
          )
        ],
        surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'activity: ${_activityCount}',
            ),
            Text(
              'partners: ${_partnersCount}',
            ),
          ],
        ),
      ),
    );
  }
}
