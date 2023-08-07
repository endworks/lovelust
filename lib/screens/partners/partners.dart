import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lovelust/screens/partners/partner_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/no_content.dart';
import 'package:lovelust/widgets/partner_item_alt.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final SharedService _shared = getIt<SharedService>();
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final ScrollController _scrollController = ScrollController();
  bool _isExtended = true;

  @override
  void initState() {
    super.initState();
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

  void _addPartner() {
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
    if (_shared.isLoggedIn) {
      _shared.partners = await _api.getPartners();
    } else {
      _shared.partners = await _storage.getPartners();
    }
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
            ),
            _shared.partners.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                      icon: Icons.person_off,
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
                        (BuildContext context, int index) => PartnerItemAlt(
                          key: Key(_shared.partners[index].id!),
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
        child: _isExtended
            ? FloatingActionButton.extended(
                onPressed: _addPartner,
                label: Text(AppLocalizations.of(context)!.addPartner),
                heroTag: "partnersAddExtended",
                icon: const Icon(Icons.person_add_alt_outlined),
              )
            : FloatingActionButton(
                onPressed: _addPartner,
                tooltip: AppLocalizations.of(context)!.addPartner,
                heroTag: "partnersAdd",
                child: const Icon(Icons.person_add_alt_outlined),
              ),
      ),
    );
  }
}
