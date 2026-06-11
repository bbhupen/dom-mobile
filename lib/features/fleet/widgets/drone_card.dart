import 'package:flutter/material.dart';

import '../models/drone.dart';
import 'drone_visuals.dart';

class DroneCard extends StatelessWidget {
  const DroneCard({
    super.key,
    required this.drone,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final Drone drone;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  DroneAvatar(name: drone.name),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drone.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${drone.manufacturer} ${drone.model}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xff536170)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Serial ${drone.serialNumber}',
                          style: const TextStyle(
                            color: Color(0xff6b7886),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusChip(status: drone.status),
                      const SizedBox(height: 6),
                      Text(
                        '${drone.totalFlightHours.toStringAsFixed(0)}h',
                        style: const TextStyle(
                          color: Color(0xff6b7886),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      drone.status == 'active'
                          ? 'Ready for assignment'
                          : 'Not available for missions',
                      style: const TextStyle(
                        color: Color(0xff6b7886),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      drone.status == 'active'
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                    tooltip: drone.status == 'active'
                        ? 'Deactivate'
                        : 'Activate',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
