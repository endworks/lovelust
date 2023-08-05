import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/screens/settings/settings.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SharedService _shared = getIt<SharedService>();

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'Settings'),
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  Widget get title {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Love', style: TextStyle(color: loveColor)),
          TextSpan(text: 'Lust', style: TextStyle(color: lustColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          GenericHeader(
            title: title,
            actions: [
              IconButton(
                onPressed: _openSettings,
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: NoContent(
              icon: Icons.analytics_outlined,
              message: AppLocalizations.of(context)!.noAnalytics,
            ),
          )
        ],
      ),
    );
  }
}
