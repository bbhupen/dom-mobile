import 'package:flutter/material.dart';

import '../../auth/models/auth_session.dart';
import '../widgets/action_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.session,
    required this.onOpenFleet,
  });

  final AuthSession session;
  final VoidCallback onOpenFleet;

  @override
  Widget build(BuildContext context) {
    final cards = [
      ActionCardData(
        'Fleet',
        'Manage drones, readiness, and maintenance.',
        droneActionIcon(),
        onOpenFleet,
      ),
      ActionCardData(
        'Requests',
        'Track incoming work and approvals.',
        materialActionIcon(Icons.inbox_outlined),
        () {},
      ),
      ActionCardData(
        'Pilots',
        'Review pilots, availability, and certificates.',
        materialActionIcon(Icons.badge_outlined),
        () {},
      ),
      ActionCardData(
        'Services',
        'Configure offerings and pricing.',
        materialActionIcon(Icons.design_services_outlined),
        () {},
      ),
      ActionCardData(
        'Missions',
        'Plan approved field work.',
        materialActionIcon(Icons.map_outlined),
        () {},
      ),
      ActionCardData(
        'Reports',
        'Review completed operation reports.',
        materialActionIcon(Icons.bar_chart_outlined),
        () {},
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
      children: [
        Text(
          'Mission control',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'Quick access to the operational areas that are not buried in the bottom nav.',
          style: TextStyle(color: Color(0xff536170), height: 1.35),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 720 ? 3 : 2;
            return GridView.builder(
              itemCount: cards.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: constraints.maxWidth > 720 ? 1.8 : 1.16,
              ),
              itemBuilder: (context, index) => ActionCard(data: cards[index]),
            );
          },
        ),
      ],
    );
  }
}
