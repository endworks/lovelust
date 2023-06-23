import 'package:flutter/material.dart';
import 'package:lovelust/screens/settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          Text('Love',
              style: TextStyle(color: Color.fromARGB(255, 252, 85, 147))),
          Text('Lust',
              style: TextStyle(color: Color.fromARGB(255, 93, 89, 217))),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _onSettingsClick,
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '#TODO',
              textScaleFactor: 3,
            )
          ],
        ),
      ),
    );
  }
}
