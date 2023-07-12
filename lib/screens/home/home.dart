import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/generic_header.dart';

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
      color2 = loveColor;
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Love', style: TextStyle(color: color1)),
          TextSpan(text: 'Lust', style: TextStyle(color: color2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            GenericHeader(
              title: title,
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _onSettingsClick,
                )
              ],
            ),
          ];
        },
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${AppLocalizations.of(context)!.journal}: ${_common.activity.length}',
              ),
              Text(
                '${AppLocalizations.of(context)!.partners}: ${_common.partners.length}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
