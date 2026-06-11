import 'package:flutter/material.dart';

import '../../../core/widgets/drone_icon.dart';

typedef ActionIconBuilder = Widget Function(Color color);

ActionIconBuilder materialActionIcon(IconData icon) {
  return (color) => Icon(icon, color: color);
}

ActionIconBuilder droneActionIcon() {
  return (color) => DroneIcon(color: color);
}

class ActionCardData {
  ActionCardData(this.title, this.body, this.icon, this.onTap);

  final String title;
  final String body;
  final ActionIconBuilder icon;
  final VoidCallback onTap;
}

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.data});

  final ActionCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data.icon(Theme.of(context).colorScheme.primary),
              const Spacer(),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xff536170)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
