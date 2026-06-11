import 'package:flutter/material.dart';

import '../../../core/widgets/sheets.dart';
import '../../fleet/widgets/drone_visuals.dart';
import '../models/service_item.dart';
import 'service_card.dart';
import 'service_helpers.dart';

enum ServiceDetailsAction { edit, toggleStatus }

class ServiceDetailsSheet extends StatelessWidget {
  const ServiceDetailsSheet({super.key, required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context) {
    return SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHeader(
            title: service.name,
            subtitle: serviceCategoryLabel(service.category),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff7f9fc),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffd8e0e8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceStatusChip(status: service.status),
                      const SizedBox(height: 10),
                      Text(
                        service.description?.isNotEmpty == true
                            ? service.description!
                            : 'No description added.',
                        style: const TextStyle(
                          color: Color(0xff536170),
                          height: 1.35,
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
                    SpecPill(
                      label: 'Price',
                      value: formatMoney(service.basePrice, service.currency),
                    ),
                    SpecPill(
                      label: 'Unit',
                      value: servicePricingUnitLabel(service.pricingUnit),
                    ),
                    if (service.estimatedDurationMinutes != null)
                      SpecPill(
                        label: 'Duration',
                        value: '${service.estimatedDurationMinutes} min',
                      ),
                  ],
                ),
                if ((service.deliverables ?? '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deliverables: ${service.deliverables!}',
                      style: const TextStyle(color: Color(0xff536170)),
                    ),
                  ),
                ],
                if ((service.notes ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      service.notes!,
                      style: const TextStyle(color: Color(0xff536170)),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(ServiceDetailsAction.edit),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(ServiceDetailsAction.toggleStatus),
                        icon: Icon(
                          service.status == 'active'
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                        ),
                        label: Text(
                          service.status == 'active'
                              ? 'Deactivate'
                              : 'Activate',
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
