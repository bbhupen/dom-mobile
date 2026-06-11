import '../../../core/utils/parsing.dart';

class RequestServiceSummary {
  RequestServiceSummary({required this.id, required this.name, required this.category});

  final String id;
  final String name;
  final String category;

  factory RequestServiceSummary.fromJson(dynamic json) {
    return RequestServiceSummary(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Service',
      category: json['category'] as String? ?? 'custom',
    );
  }
}

class RequestItem {
  RequestItem({
    required this.id,
    required this.source,
    required this.customerName,
    required this.contactPhone,
    required this.serviceType,
    required this.siteLocation,
    required this.description,
    required this.urgency,
    required this.status,
    required this.createdAt,
    this.serviceId,
    this.preferredDate,
    this.quoteAmount,
    this.notes,
    this.service,
  });

  final String id;
  final String source;
  final String customerName;
  final String contactPhone;
  final String serviceType;
  final String siteLocation;
  final String description;
  final String urgency;
  final String status;
  final String createdAt;
  final String? serviceId;
  final String? preferredDate;
  final double? quoteAmount;
  final String? notes;
  final RequestServiceSummary? service;

  factory RequestItem.fromJson(dynamic json) {
    return RequestItem(
      id: json['id'] as String? ?? '',
      source: json['source'] as String? ?? 'admin_created',
      customerName: json['customerName'] as String? ?? 'Unknown customer',
      contactPhone: json['contactPhone'] as String? ?? '',
      serviceType: json['serviceType'] as String? ?? 'Service request',
      siteLocation: json['siteLocation'] as String? ?? 'Not set',
      preferredDate: json['preferredDate'] as String?,
      description: json['description'] as String? ?? '',
      urgency: json['urgency'] as String? ?? 'normal',
      status: json['status'] as String? ?? 'submitted',
      quoteAmount: nullableDouble(json['quoteAmount']),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      serviceId: json['serviceId'] as String?,
      service: json['service'] == null ? null : RequestServiceSummary.fromJson(json['service']),
    );
  }
}
