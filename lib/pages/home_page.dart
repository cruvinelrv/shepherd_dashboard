// lib/screens/home_screen.dart
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
      final dashboardYamlPath = '${dir}/.shepherd/dashboard.yaml';
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
              child: const Text('Select Shepherd Project Directory'),
              onPressed: _selectProjectDirectory,
            ),
            if (selectedProjectPath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected: $selectedProjectPath'),
              ),
            ElevatedButton(
              child: const Text('Domains'),
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DomainsPage()),
                      ),
            ),
            ElevatedButton(
              child: const Text('Owners'),
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OwersPage()),
                      ),
            ),
            ElevatedButton(
              child: const Text('Microfrontends'),
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MicrofrontendsPage()),
                      ),
            ),
            ElevatedButton(
              child: const Text('Changelog'),
              onPressed:
                  selectedProjectPath == null
                      ? null
                      : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangeLogPage()),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
