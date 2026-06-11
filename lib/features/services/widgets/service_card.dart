import 'package:flutter/material.dart';

import '../models/service_item.dart';
import 'service_helpers.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final ServiceItem service;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: serviceCategoryColor(service.category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.design_services_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceCategoryLabel(service.category),
                          style: const TextStyle(color: Color(0xff536170)),
                        ),
                      ],
                    ),
                  ),
                  ServiceStatusChip(status: service.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                service.description?.isNotEmpty == true
                    ? service.description!
                    : 'No description added.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xff536170), height: 1.35),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${formatMoney(service.basePrice, service.currency)} • ${servicePricingUnitLabel(service.pricingUnit)}',
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
                      service.status == 'active'
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                    tooltip: service.status == 'active'
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

class ServiceStatusChip extends StatelessWidget {
  const ServiceStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffdff1e8) : const Color(0xffeef2f6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive ? 'active' : 'inactive',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}
