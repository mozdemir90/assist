import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.check_box_outlined),
            selectedIcon: const Icon(Icons.check_box),
            label: 'tasks'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_outlined),
            selectedIcon: const Icon(Icons.list),
            label: 'lists'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.directions_run_outlined),
            selectedIcon: const Icon(Icons.directions_run),
            label: 'activities'.tr(),
          ),
        ],
      ),
    );
  }
}
