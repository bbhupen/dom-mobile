import '../../../core/utils/parsing.dart';
import 'service_item.dart';

class ServicePage {
  ServicePage({required this.items, required this.meta, required this.summary});

  final List<ServiceItem> items;
  final ServicePageMeta meta;
  final ServiceSummary summary;

  factory ServicePage.fromJson(dynamic json) {
    if (json is List) {
      final services = json.map((item) => ServiceItem.fromJson(item)).toList();
      return ServicePage(
        items: services,
        meta: ServicePageMeta(
          page: 1,
          pageSize: services.length,
          total: services.length,
          totalPages: 1,
        ),
        summary: ServiceSummary.fromServices(services),
      );
    }

    final items = (json['items'] as List? ?? [])
        .map((item) => ServiceItem.fromJson(item))
        .toList();
    return ServicePage(
      items: items,
      meta: ServicePageMeta.fromJson(json['meta'], fallbackCount: items.length),
      summary: ServiceSummary.fromJson(json['summary'], items),
    );
  }
}

class ServicePageMeta {
  ServicePageMeta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  factory ServicePageMeta.fromJson(dynamic json, {required int fallbackCount}) {
    return ServicePageMeta(
      page: asInt(json?['page'], 1),
      pageSize: asInt(json?['pageSize'], fallbackCount),
      total: asInt(json?['total'], fallbackCount),
      totalPages: asInt(json?['totalPages'], 1),
    );
  }
}

class ServiceSummary {
  ServiceSummary({required this.activeCount, required this.inactiveCount});

  final int activeCount;
  final int inactiveCount;

  factory ServiceSummary.fromJson(
    dynamic json,
    List<ServiceItem> fallbackServices,
  ) {
    if (json == null) {
      return ServiceSummary.fromServices(fallbackServices);
    }

    return ServiceSummary(
      activeCount: asInt(json['activeCount'], 0),
      inactiveCount: asInt(json['inactiveCount'], 0),
    );
  }

  factory ServiceSummary.fromServices(List<ServiceItem> services) {
    return ServiceSummary(
      activeCount: services
          .where((service) => service.status == 'active')
          .length,
      inactiveCount: services
          .where((service) => service.status == 'inactive')
          .length,
    );
  }
}
