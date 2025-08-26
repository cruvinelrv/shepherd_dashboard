// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shepherd_dashboard/pages/change_log_page.dart';
import 'package:shepherd_dashboard/pages/domains_page.dart';
import 'package:shepherd_dashboard/pages/microfrontends_page.dart';
import 'package:shepherd_dashboard/pages/owers_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shepherd Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Domains'),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DomainsPage()),
                  ),
            ),
            ElevatedButton(
              child: const Text('Owners'),
              onPressed:
                  () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const OwersPage())),
            ),
            ElevatedButton(
              child: const Text('Microfrontends'),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MicrofrontendsPage()),
                  ),
            ),
            ElevatedButton(
              child: const Text('Changelog'),
              onPressed:
                  () => Navigator.push(
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
