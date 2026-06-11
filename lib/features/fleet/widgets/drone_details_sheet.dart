import 'package:flutter/material.dart';

import '../../../core/widgets/sheets.dart';
import '../models/drone.dart';
import 'drone_visuals.dart';

class DroneDetailsSheet extends StatelessWidget {
  const DroneDetailsSheet({super.key, required this.drone});

  final Drone drone;

  @override
  Widget build(BuildContext context) {
    return SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHeader(
            title: drone.name,
            subtitle: '${drone.manufacturer} ${drone.model}',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff7f9fc),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffd8e0e8)),
                  ),
                  child: Row(
                    children: [
                      DroneAvatar(name: drone.name, large: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusChip(status: drone.status),
                            const SizedBox(height: 8),
                            Text(
                              '${drone.totalFlightHours.toStringAsFixed(0)} total flight hours',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SpecPill(label: 'Serial', value: drone.serialNumber),
                    if (drone.uin != null)
                      SpecPill(label: 'UIN', value: drone.uin!),
                    if (drone.category != null)
                      SpecPill(label: 'Category', value: drone.category!),
                    if (drone.weightKg != null)
                      SpecPill(label: 'Weight', value: '${drone.weightKg} kg'),
                    if (drone.payloadCapacityKg != null)
                      SpecPill(
                        label: 'Payload',
                        value: '${drone.payloadCapacityKg} kg',
                      ),
                  ],
                ),
                if ((drone.notes ?? '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      drone.notes!,
                      style: const TextStyle(color: Color(0xff536170)),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.of(context).pop(DroneDetailsAction.edit),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(DroneDetailsAction.toggleStatus),
                        icon: Icon(
                          drone.status == 'active'
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                        ),
                        label: Text(
                          drone.status == 'active' ? 'Deactivate' : 'Activate',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum DroneDetailsAction { edit, toggleStatus }
