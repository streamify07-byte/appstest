import 'package:flutter/material.dart';

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome to IPTV', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Explore Live TV, Movies, and Series with a modern Material 3 UI.',
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
