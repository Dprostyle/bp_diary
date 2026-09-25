import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/features/add/add_measurement_screen.dart';
import 'package:bp_diary/features/history/history_screen.dart';
import 'package:bp_diary/features/settings/settings_screen.dart';
import 'package:bp_diary/features/shell/app_bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = AppBottomBar.historyIndex;

  Future<void> _openAdd() async {
    final saved = await Navigator.of(context).push<bool>(
      CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (context) => const AddMeasurementScreen(),
      ),
    );
    if (saved == true && mounted) {
      setState(() => _index = AppBottomBar.historyIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: _index,
                children: const [HistoryScreen(), SettingsScreen()],
              ),
            ),
          ),
          AppBottomBar(
            index: _index,
            onHistory: () => setState(() => _index = AppBottomBar.historyIndex),
            onSettings: () =>
                setState(() => _index = AppBottomBar.settingsIndex),
            onAdd: _openAdd,
          ),
        ],
      ),
    );
  }
}
