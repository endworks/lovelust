import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:lovelust/screens/partners/partner_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';
import 'package:lovelust/widgets/partner_card.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final SharedService _shared = getIt<SharedService>();
  final StorageService _storage = getIt<StorageService>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<State<StatefulWidget>> fabKey = GlobalKey();
  Size? fabSize;
  bool _isExtended = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final box = fabKey.currentContext?.findRenderObject();
        fabSize = (box as RenderBox).size;
      });
    });
    _scrollController.addListener(() {
      setState(() {
        _isExtended = _scrollController.offset <= 0.0;
      });
    });
    _shared.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void addPartner() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        fullscreenDialog: true,
        settings: const RouteSettings(name: 'PartnerAdd'),
        builder: (BuildContext context) => const PartnerAddPage(),
      ),
    );
  }

  Future<void> refresh() async {
    _shared.partners = await _storage.getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: _shared.partners.isNotEmpty
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            GenericHeader(
              title: Text(AppLocalizations.of(context)!.partners),
              scrolled: !_isExtended,
            ),
            _shared.partners.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                      icon: Icons.person,
                      message: AppLocalizations.of(context)!.noPartners,
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).padding.left,
                      0,
                      MediaQuery.of(context).padding.right,
                      MediaQuery.of(context).padding.bottom,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => PartnerCard(
                          key: ObjectKey(_shared.partners[index].id!),
                          partner: _shared.partners[index],
                        ),
                        childCount: _shared.partners.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).padding.bottom
              : 0,
        ),
        child: AnimatedContainer(
          width: _isExtended ? fabSize?.width : fabSize?.height,
          // width: fabSize?.width,
          height: fabSize?.height,
          duration: Duration(milliseconds: 100),
          child: FloatingActionButton.extended(
            onPressed: addPartner,
            key: fabKey,
            heroTag: "partnerAdd",
            label: AnimatedSize(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
              child: Container(
                child: _isExtended
                    ? Text(
                        AppLocalizations.of(context)!.addPartner,
                      )
                    : Icon(
                        Icons.person_add_alt_outlined,
                      ),
              ),
            ),
            icon: _isExtended ? Icon(Icons.person_add_alt_outlined) : null,
          ),
        ),
      ),
    );
  }
}
