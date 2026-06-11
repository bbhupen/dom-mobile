import '../../../core/utils/parsing.dart';
import 'drone.dart';

class DronePage {
  DronePage({required this.items, required this.meta, required this.summary});

  final List<Drone> items;
  final PageMeta meta;
  final FleetSummary summary;

  factory DronePage.fromJson(dynamic json) {
    if (json is List) {
      final drones = json.map((item) => Drone.fromJson(item)).toList();
      return DronePage(
        items: drones,
        meta: PageMeta(
          page: 1,
          pageSize: drones.length,
          total: drones.length,
          totalPages: 1,
        ),
        summary: FleetSummary.fromDrones(drones),
      );
    }

    final items = (json['items'] as List? ?? [])
        .map((item) => Drone.fromJson(item))
        .toList();
    return DronePage(
      items: items,
      meta: PageMeta.fromJson(json['meta'], fallbackCount: items.length),
      summary: FleetSummary.fromJson(json['summary'], items),
    );
  }
}

class PageMeta {
  PageMeta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  factory PageMeta.fromJson(dynamic json, {required int fallbackCount}) {
    return PageMeta(
      page: asInt(json?['page'], 1),
      pageSize: asInt(json?['pageSize'], fallbackCount),
      total: asInt(json?['total'], fallbackCount),
      totalPages: asInt(json?['totalPages'], 1),
    );
  }
}

class FleetSummary {
  FleetSummary({
    required this.activeCount,
    required this.maintenanceCount,
    required this.totalFlightHours,
  });

  final int activeCount;
  final int maintenanceCount;
  final double totalFlightHours;

  factory FleetSummary.fromJson(dynamic json, List<Drone> fallbackDrones) {
    if (json == null) {
      return FleetSummary.fromDrones(fallbackDrones);
    }

    return FleetSummary(
      activeCount: asInt(json['activeCount'], 0),
      maintenanceCount: asInt(json['maintenanceCount'], 0),
      totalFlightHours: asDouble(json['totalFlightHours'], 0),
    );
  }

  factory FleetSummary.fromDrones(List<Drone> drones) {
    return FleetSummary(
      activeCount: drones.where((drone) => drone.status == 'active').length,
      maintenanceCount: drones
          .where((drone) => drone.status == 'under_maintenance')
          .length,
      totalFlightHours: drones.fold(
        0,
        (total, drone) => total + drone.totalFlightHours,
      ),
    );
  }
}
