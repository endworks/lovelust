import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lovelust/models/destination.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/widgets/partner_item.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key, required this.destination});

  final Destination destination;

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final storage = const FlutterSecureStorage();
  String? accessToken;
  List<Partner> partners = [];

  Future<void> _readData() async {
    accessToken = await storage.read(key: 'access_token');
    final persistedPartners = await storage.read(key: 'partners');
    if (persistedPartners != null) {
      setState(() {
        partners = jsonDecode(persistedPartners)
            .map<Partner>((map) => Partner.fromJson(map))
            .toList();
      });
    }
  }

  Future<List<Partner>> _getPartners() async {
    final response = await http.get(
      Uri.parse('https://lovelust-api.end.works/partner'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
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
      _readData().then((value) async {
        if (accessToken != null && partners.isEmpty) {
          partners = await _getPartners();
          setState(() {
            partners = partners;
          });
          await storage.write(key: 'partners', value: jsonEncode(partners));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.separated(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: partners.length,
              itemBuilder: (context, index) =>
                  PartnerItem(partner: partners[index]))),
    );
  }
}
