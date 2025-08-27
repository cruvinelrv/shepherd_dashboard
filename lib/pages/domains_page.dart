import 'package:flutter/material.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

class DomainsPage extends StatefulWidget {
  final String projectPath;
  const DomainsPage({super.key, required this.projectPath});

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
      final yamlPath = '${widget.projectPath}/.shepherd/domains.yaml';
      final file = File(yamlPath);
      if (!file.existsSync()) {
        setState(() {
          error = 'domains.yaml not found.';
        });
        return;
      }
      final content = await file.readAsString();
      final yamlMap = loadYaml(content);
      setState(() {
        domains = yamlMap['domains'] is List ? yamlMap['domains'] : [];
        squads = yamlMap['squads'] is List ? yamlMap['squads'] : [];
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        domains = [];
        squads = [];
      });
    }
  }

  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text('Selected: ${widget.projectPath}')),
        Expanded(
          child:
              error != null
                  ? Center(child: Text('Error: $error'))
                  : domains == null
                  ? const Center(child: Text('Loading...'))
                  : ListView(
                    children: [
                      if (domains!.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Domains',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
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
                      if (squads!.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Squads',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...squads!.map(
                          (squad) => Card(
                            child: ListTile(
                              title: Text(squad['name'] ?? ''),
                              subtitle: Text(
                                'Members: ${(squad['members'] as List?)?.join(', ') ?? ''}',
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (domains!.isEmpty && squads!.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No data found in domains.yaml.'),
                        ),
                    ],
                  ),
        ),
      ],
    );
  }
}
