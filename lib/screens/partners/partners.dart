import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/generic_header.dart';
import 'package:lovelust/widgets/partner_item.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final CommonService _common = getIt<CommonService>();
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final ScrollController _scrollController = ScrollController();
  List<Partner> _partners = [];
  bool _isExtended = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isExtended = _scrollController.offset <= 0.0;
      });
    });

    setState(() {
      _partners = _common.partners;
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
      _partners = await _api.getPartners();
    } else {
      _partners = await _storage.getPartners();
    }
    _common.partners = _partners;
    setState(() {
      _partners = _partners;
    });
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
            const GenericHeader(
              title: Text('Partners'),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => PartnerItem(
                  key: Key(_partners[index].id),
                  partner: _partners[index],
                ),
                childCount: _partners.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isExtended
          ? FloatingActionButton.extended(
              onPressed: _addPartner,
              label: const Text('Add partner'),
              icon: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _addPartner,
              tooltip: 'Add partner',
              child: const Icon(Icons.add),
            ),
    );
  }
}
