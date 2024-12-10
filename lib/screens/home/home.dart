import 'package:flutter/material.dart';
import 'package:lovelust/colors.dart';
import 'package:lovelust/l10n/app_localizations.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh();
    });
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 0.0;
      });
    });
    _shared.addListener(() {
      try {
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        refresh();
      }
    });
  }

  Widget get title {
    Color colorLove;
    Color colorLust;

    //if (_shared.colorScheme == null) {
    colorLove = loveColor;
    colorLust = lustColor;
    /*} else {
      colorLove =
          _shared.generateAltColor(Theme.of(context).colorScheme.primary);
      colorLust = Theme.of(context).colorScheme.primary;
    }*/

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
    _shared.statistics = _shared.generateStatsWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: _shared.statistics.isNotEmpty
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            GenericHeader(
              title: title,
              scrolled: _isScrolled,
            ),
            _shared.statistics.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                      icon: Icons.analytics,
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
