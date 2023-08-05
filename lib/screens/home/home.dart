import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/colors.dart';
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

  Widget get title {
    Color color1 = loveColor;
    Color color2 = lustColor;

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
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          GenericHeader(
            title: title,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: NoContent(
              icon: Icons.content_paste_off,
              message: AppLocalizations.of(context)!.noSummary,
            ),
          )
        ],
      ),
    );
  }
}
