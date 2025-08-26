import 'package:flutter/material.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  List<dynamic>? domains;
  List<dynamic>? squads;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadYamlData();
  }

  Future<void> _loadYamlData() async {
    try {
      // Precisa do pacote yaml e path
      final yaml = await _readYamlFile('../../domains.yaml');
      setState(() {
        domains = yaml['domains'] as List<dynamic>?;
        squads = yaml['squads'] as List<dynamic>?;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Future<Map<String, dynamic>> _readYamlFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    final yamlMap = loadYaml(content);
    return Map<String, dynamic>.from(yamlMap);
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('Erro: $error'));
    }
    if (domains == null && squads == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        if (domains != null) ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Domains', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...domains!.map(
            (domain) => Card(
              child: ListTile(
                title: Text(domain['name'] ?? ''),
                subtitle: Text(
                  'Owners: ${(domain['owners'] as List?)?.map((o) => o['first_name']).join(', ') ?? ''}',
                ),
              ),
            ),
          ),
        ],
        if (squads != null) ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Squads', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...squads!.map(
            (squad) => Card(
              child: ListTile(
                title: Text(squad['name'] ?? ''),
                subtitle: Text('Members: ${(squad['members'] as List?)?.join(', ') ?? ''}'),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
