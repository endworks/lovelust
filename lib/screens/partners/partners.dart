import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/partner_item.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final StorageService _storageService = getIt<StorageService>();
  List<Partner> partners = [];

  Future<void> _readData() async {
    final persistedPartners = await _storageService.getPartners();
    setState(() {
      partners = persistedPartners;
    });
  }

  Future<List<Partner>> _getPartners() async {
    final response = await http.get(
      Uri.parse('https://lovelust-api.end.works/partner'),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${await _storageService.getAccessToken()}',
      },
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Partner>((map) => Partner.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load partners');
    }
  }

  Future<void> _pullRefresh() async {
    partners = await _getPartners();
    setState(() {
      partners = partners;
    });
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();

      if (_storageService.accessToken != null && partners.isEmpty) {
        _getPartners().then((value) async {
          setState(() {
            partners = value;
          });
          await _storageService.setPartners(partners);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: partners.length,
              itemBuilder: (context, index) =>
                  PartnerItem(partner: partners[index]))),
    );
  }
}
