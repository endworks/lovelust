import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/screens/partners/partner_add.dart';
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
  final StorageService storage = getIt<StorageService>();
  final ApiService api = getIt<ApiService>();
  List<Partner> partners = [];
  ScrollController scrollController = ScrollController();
  bool isExtended = true;

  Future<List<dynamic>> loadData() {
    debugPrint('loadData partners');
    var futures = <Future>[
      storage.getPartners(),
    ];
    return Future.wait(futures);
  }

  void addPartner() {
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
    partners = await api.getPartners();
    await storage.setPartners(partners);
    setState(() {
      partners = partners;
    });
  }

  @override
  void initState() {
    scrollController.addListener(() {
      setState(() {
        isExtended = scrollController.offset <= 0.0;
      });
    });

    setState(() {
      partners = storage.partners;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) =>
          Scaffold(
        appBar: AppBar(
          title: const Text('Partners'),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: partners.length,
            itemBuilder: (context, index) =>
                PartnerItem(partner: partners[index]),
          ),
        ),
        floatingActionButton: isExtended
            ? FloatingActionButton.extended(
                onPressed: addPartner,
                label: const Text('Add partner'),
                icon: const Icon(Icons.add),
              )
            : FloatingActionButton(
                onPressed: addPartner,
                tooltip: 'Add partner',
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
