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

  Widget get title {
    Color color1 = Theme.of(context).colorScheme.onSurface;
    Color color2 = Theme.of(context).colorScheme.onSurface;
    if (!_common.monochrome) {
      color1 = loveColor;
      color2 = lustColor;
    }
    return Row(children: [
      Text('Love', style: TextStyle(color: color1)),
      Text('Lust', style: TextStyle(color: color2)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
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
