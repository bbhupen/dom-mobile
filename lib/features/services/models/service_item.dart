import '../../../core/utils/parsing.dart';

class ServiceItem {
  ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.pricingUnit,
    required this.currency,
    this.description,
    this.basePrice,
    this.estimatedDurationMinutes,
    this.deliverables,
    this.notes,
  });

  final String id;
  final String name;
  final String category;
  final String status;
  final String pricingUnit;
  final String currency;
  final String? description;
  final double? basePrice;
  final int? estimatedDurationMinutes;
  final String? deliverables;
  final String? notes;

  factory ServiceItem.fromJson(dynamic json) {
    return ServiceItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed service',
      category: json['category'] as String? ?? 'custom',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'inactive',
      pricingUnit: json['pricingUnit'] as String? ?? 'per_project',
      basePrice: nullableDouble(json['basePrice']),
      currency: json['currency'] as String? ?? 'INR',
      estimatedDurationMinutes: nullableInt(json['estimatedDurationMinutes']),
      deliverables: json['deliverables'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
