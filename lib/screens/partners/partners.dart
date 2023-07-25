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
  final SharedService _common = getIt<SharedService>();
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

    _common.addListener(() {
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
          builder: (BuildContext context) {
            return const PartnerAddPage();
          }),
    );
  }

  Future<void> refresh() async {
    if (_common.isLoggedIn) {
      _common.partners = await _api.getPartners();
    } else {
      _common.partners = await _storage.getPartners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: refresh,
        edgeOffset: 112.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            GenericHeader(
              title: Text(AppLocalizations.of(context)!.partners),
            ),
            _common.partners.isEmpty
                ? SliverFillRemaining(
                    child: NoContent(
                        message: AppLocalizations.of(context)!.noPartners),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => PartnerItemAlt(
                        key: Key(_common.partners[index].id!),
                        partner: _common.partners[index],
                      ),
                      childCount: _common.partners.length,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: _isExtended
          ? FloatingActionButton.extended(
              onPressed: _addPartner,
              label: Text(AppLocalizations.of(context)!.addPartner),
              icon: const Icon(Icons.person_add_alt_outlined),
            )
          : FloatingActionButton(
              onPressed: _addPartner,
              tooltip: AppLocalizations.of(context)!.addPartner,
              child: const Icon(Icons.person_add_alt_outlined),
            ),
    );
  }
}
