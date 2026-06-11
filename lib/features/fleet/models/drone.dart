import '../../../core/utils/parsing.dart';

class Drone {
  Drone({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.totalFlightHours,
    this.uin,
    this.category,
    this.weightKg,
    this.payloadCapacityKg,
    this.notes,
  });

  final String id;
  final String name;
  final String manufacturer;
  final String model;
  final String serialNumber;
  final String status;
  final double totalFlightHours;
  final String? uin;
  final String? category;
  final double? weightKg;
  final double? payloadCapacityKg;
  final String? notes;

  factory Drone.fromJson(dynamic json) {
    return Drone(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed drone',
      manufacturer: json['manufacturer'] as String? ?? 'Unknown',
      model: json['model'] as String? ?? 'Unknown model',
      serialNumber: json['serialNumber'] as String? ?? 'Not set',
      uin: json['uin'] as String?,
      category: json['category'] as String?,
      weightKg: nullableDouble(json['weightKg']),
      payloadCapacityKg: nullableDouble(json['payloadCapacityKg']),
      status: json['status'] as String? ?? 'grounded',
      totalFlightHours: asDouble(json['totalFlightHours'], 0),
      notes: json['notes'] as String?,
    );
  }
}
