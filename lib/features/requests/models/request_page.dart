import '../../../core/utils/parsing.dart';
import 'request_item.dart';

class RequestPage {
  RequestPage({required this.items, required this.meta, required this.summary});

  final List<RequestItem> items;
  final RequestPageMeta meta;
  final RequestSummary summary;

  factory RequestPage.fromJson(dynamic json) {
    if (json is List) {
      final requests = json.map((item) => RequestItem.fromJson(item)).toList();
      return RequestPage(
        items: requests,
        meta: RequestPageMeta(
          page: 1,
          pageSize: requests.length,
          total: requests.length,
          totalPages: 1,
        ),
        summary: RequestSummary.fromRequests(requests),
      );
    }

    final items = (json['items'] as List? ?? [])
        .map((item) => RequestItem.fromJson(item))
        .toList();
    return RequestPage(
      items: items,
      meta: RequestPageMeta.fromJson(json['meta'], fallbackCount: items.length),
      summary: RequestSummary.fromJson(json['summary'], items),
    );
  }
}

class RequestPageMeta {
  RequestPageMeta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  factory RequestPageMeta.fromJson(dynamic json, {required int fallbackCount}) {
    return RequestPageMeta(
      page: asInt(json?['page'], 1),
      pageSize: asInt(json?['pageSize'], fallbackCount),
      total: asInt(json?['total'], fallbackCount),
      totalPages: asInt(json?['totalPages'], 1),
    );
  }
}

class RequestSummary {
  RequestSummary({
    required this.openCount,
    required this.urgentCount,
    required this.quotedCount,
  });

  final int openCount;
  final int urgentCount;
  final int quotedCount;

  factory RequestSummary.fromJson(dynamic json, List<RequestItem> fallbackRequests) {
    if (json == null) {
      return RequestSummary.fromRequests(fallbackRequests);
    }

    return RequestSummary(
      openCount: asInt(json['openCount'], 0),
      urgentCount: asInt(json['urgentCount'], 0),
      quotedCount: asInt(json['quotedCount'], 0),
    );
  }

  factory RequestSummary.fromRequests(List<RequestItem> requests) {
    const openStatuses = {'submitted', 'under_review', 'more_info_required'};

    return RequestSummary(
      openCount: requests.where((request) => openStatuses.contains(request.status)).length,
      urgentCount: requests.where((request) => request.urgency == 'urgent').length,
      quotedCount: requests.where((request) => request.status == 'quote_sent').length,
    );
  }
}
