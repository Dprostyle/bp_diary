import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../add/add_measurement_screen.dart';
import '../home/dashboard_screen.dart';
import '../settings/settings_screen.dart';
import 'app_bottom_nav.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  var _index = 0;

  void _openAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddMeasurementScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _index = 0);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: IndexedStack(
                  index: _index,
                  children: [
                    DashboardScreen(
                      onOpenSettings: () => setState(() => _index = 1),
                    ),
                    const SettingsScreen(),
                  ],
                ),
              ),
            ),
            AppBottomNav(
              index: _index,
              onHistory: () => setState(() => _index = 0),
              onSettings: () => setState(() => _index = 1),
              onAdd: _openAdd,
            ),
          ],
        ),
      ),
    );
  }
}
