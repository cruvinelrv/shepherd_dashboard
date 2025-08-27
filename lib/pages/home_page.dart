import 'package:flutter/material.dart';
import 'package:shepherd_dashboard/pages/change_log_page.dart';
import 'package:shepherd_dashboard/pages/domains_page.dart';
import 'package:shepherd_dashboard/pages/microfrontends_page.dart';
import 'package:shepherd_dashboard/pages/owers_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedProjectPath;

  @override
  void initState() {
    super.initState();
    _loadProjectPathFromDashboardYaml();
  }

  Future<void> _loadProjectPathFromDashboardYaml() async {
    try {
      final dashboardFile = File('.shepherd/dashboard.yaml');
      if (dashboardFile.existsSync()) {
        final content = await dashboardFile.readAsString();
        final yaml = content.split(':');
        if (yaml.length > 1) {
          final path = yaml[1].trim().replaceAll('"', '');
          if (path.isNotEmpty) {
            setState(() {
              selectedProjectPath = path;
            });
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _selectProjectDirectory() async {
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null) {
      setState(() {
        selectedProjectPath = dir;
      });
      // Persist selection in dashboard.yaml
      final dashboardYamlPath = '$dir/.shepherd/dashboard.yaml';
      final file = File(dashboardYamlPath);
      await file.writeAsString('selected_project_path: "$dir"\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shepherd Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectProjectDirectory,
              child: const Text('Select Shepherd Project Directory'),
            ),
            if (selectedProjectPath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected: $selectedProjectPath'),
              ),
            ElevatedButton(
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DomainsPage(projectPath: selectedProjectPath!),
                        ),
                      ),
              child: const Text('Domains'),
            ),
            ElevatedButton(
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OwersPage()),
                      ),
              child: const Text('Owners'),
            ),
            ElevatedButton(
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MicrofrontendsPage()),
                      ),
              child: const Text('Microfrontends'),
            ),
            ElevatedButton(
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangeLogPage()),
                      ),
              child: const Text('Changelog'),
            ),
          ],
        ),
      ),
    );
  }
}
