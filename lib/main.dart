import 'package:flutter/material.dart';
import 'package:shepherd_dashboard/pages/home_page.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shepherd Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
