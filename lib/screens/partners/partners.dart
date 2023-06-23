import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/partner_item.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final StorageService storageService = getIt<StorageService>();
  final ApiService api = getIt<ApiService>();
  List<Partner> partners = [];

  Future<void> refresh() async {
    partners = await api.getPartners();
    await storageService.setPartners(partners);
    setState(() {
      partners = partners;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      partners = storageService.partners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresh,
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: partners.length,
              itemBuilder: (context, index) =>
                  PartnerItem(partner: partners[index]))),
    );
  }
}
