import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_add.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/widgets/partner_item.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final CommonService _common = getIt<CommonService>();
  final ApiService _api = getIt<ApiService>();
  List<Partner> _partners = [];
  ScrollController _scrollController = ScrollController();
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
    _partners = await _api.getPartners();
    _common.partners = _partners;
    setState(() {
      _partners = _partners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _partners.length,
          itemBuilder: (context, index) =>
              PartnerItem(partner: _partners[index]),
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
