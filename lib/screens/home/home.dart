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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shared.statistics = _shared.generateStatistics();
    });
    _shared.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        settings: const RouteSettings(name: 'Settings'),
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  Color generateAltColor(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    return hslColor.withHue(hslColor.hue - 20).toColor();
  }

  Widget get title {
    Color colorLove = generateAltColor(Theme.of(context).colorScheme.primary);
    Color colorLust = Theme.of(context).colorScheme.primary;

    if (_shared.colorScheme == null) {
      colorLove = loveColor;
      colorLust = lustColor;
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Love', style: TextStyle(color: colorLove)),
          TextSpan(text: 'Lust', style: TextStyle(color: colorLust)),
        ],
      ),
    );
  }

  Future<void> refresh() async {
    _shared.statistics = _shared.generateStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          physics: _shared.statistics.isNotEmpty
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
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
            _shared.statistics.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                      icon: Icons.analytics_outlined,
                      message: AppLocalizations.of(context)!.noStatistics,
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).padding.left,
                      0,
                      MediaQuery.of(context).padding.right,
                      MediaQuery.of(context).padding.bottom,
                    ),
                    sliver: SliverList.builder(
                      itemCount: _shared.statistics.length,
                      itemBuilder: (context, index) =>
                          _shared.statistics[index],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
