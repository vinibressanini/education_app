import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Placeholder(
        child: Center(
          child: Text('DASHBOARD SCREEN'),
        ),
      ),
    );
  }
}
