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
