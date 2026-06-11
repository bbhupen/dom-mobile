import 'package:flutter/material.dart';

import '../core/widgets/drone_icon.dart';
import '../features/auth/models/auth_session.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/fleet/screens/fleet_screen.dart';
import '../features/services/screens/services_screen.dart';

class OrgShell extends StatefulWidget {
  const OrgShell({super.key, required this.session, required this.onSignOut});

  final AuthSession session;
  final VoidCallback onSignOut;

  @override
  State<OrgShell> createState() => _OrgShellState();
}

class _OrgShellState extends State<OrgShell> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        session: widget.session,
        onOpenFleet: () => setState(() => tabIndex = 1),
      ),
      FleetScreen(session: widget.session),
      PlaceholderScreen(title: 'Pilots', icon: Icons.badge_outlined),
      PlaceholderScreen(title: 'Requests', icon: Icons.inbox_outlined),
      ServicesScreen(session: widget.session),
    ];

    return PopScope(
      canPop: tabIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && tabIndex != 0) {
          setState(() => tabIndex = 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Drone operations',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              Text(
                widget.session.user.name,
                style: const TextStyle(fontSize: 12, color: Color(0xff6b7886)),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              onPressed: widget.onSignOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: pages[tabIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tabIndex,
          onDestinationSelected: (value) => setState(() => tabIndex = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: DroneIcon(),
              selectedIcon: DroneIcon(filled: true),
              label: 'Fleet',
            ),
            NavigationDestination(
              icon: Icon(Icons.badge_outlined),
              selectedIcon: Icon(Icons.badge),
              label: 'Pilots',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(Icons.inbox),
              label: 'Requests',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_outlined),
              selectedIcon: Icon(Icons.apps),
              label: 'Services',
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$title workspace is ready for the next feature pass.',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
