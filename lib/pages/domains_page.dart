import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  String? projectPath;
  List<dynamic>? domains;
  List<dynamic>? squads;
  String? error;

  Future<void> _pickProjectDirectory() async {
    String? selectedDir = await FilePicker.platform.getDirectoryPath();
    if (selectedDir != null) {
      setState(() {
        projectPath = selectedDir;
        domains = null;
        squads = null;
        error = null;
      });
      await _loadYamlData();
    }
  }

  Future<void> _loadYamlData() async {
    if (projectPath == null) return;
    final yamlPath = '$projectPath/.shepherd/domains.yaml';
    try {
      final file = File(yamlPath);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickProjectDirectory,
          child: const Text('Select Shepherd Project Directory'),
        ),
        if (projectPath != null)
          Padding(padding: const EdgeInsets.all(8.0), child: Text('Selected: $projectPath')),
        Expanded(
          child:
              error != null
                  ? Center(child: Text('Error: $error'))
                  : domains == null
                  ? const Center(child: Text('Select a project directory to load data.'))
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
