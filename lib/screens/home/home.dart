import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CommonService _common = getIt<CommonService>();

  void _onSettingsClick() {
    Navigator.push(context,
        MaterialPageRoute<Widget>(builder: (BuildContext context) {
      return const SettingsPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Text('Love', style: TextStyle(color: loveColor)),
          Text('Lust', style: TextStyle(color: lustColor)),
        ]),
        actions: [
          IconButton(
            icon: CircleAvatar(
                child:
                    Icon(_common.isLoggedIn ? Icons.person : Icons.person_off)),
            onPressed: _onSettingsClick,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'activity: ${_common.activity.length}',
            ),
            Text(
              'partners: ${_common.partners.length}',
            ),
          ],
        ),
      ),
    );
  }
}
