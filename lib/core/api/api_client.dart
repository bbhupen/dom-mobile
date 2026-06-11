import 'dart:convert';
import 'dart:io';

import '../../app/app_config.dart';
import '../../features/auth/models/auth_session.dart';
import '../../features/fleet/models/drone_page.dart';
import '../../features/requests/models/request_page.dart';
import '../../features/services/models/service_page.dart';

class ApiClient {
  Future<AuthSession> login(String email, String password) async {
    final data = await request(
      '/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );
    return AuthSession.fromJson(data);
  }

  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required String organizationName,
  }) async {
    final data = await request(
      '/auth/signup',
      method: 'POST',
      body: {
        'name': name,
        'email': email,
        'password': password,
        if (organizationName.isNotEmpty) 'organizationName': organizationName,
      },
    );
    return AuthSession.fromJson(data);
  }

  Future<DronePage> fetchDrones(
    String token, {
    required int page,
    required int pageSize,
    required String search,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (search.isNotEmpty) 'search': search,
    };
    final path = Uri(path: '/fleet/drones', queryParameters: params).toString();
    final data = await request(path, token: token);
    return DronePage.fromJson(data);
  }

  Future<void> createDrone(String token, Map<String, Object?> input) async {
    await request('/fleet/drones', method: 'POST', token: token, body: input);
  }

  Future<void> updateDrone(
    String token,
    String id,
    Map<String, Object?> input,
  ) async {
    await request(
      '/fleet/drones/$id',
      method: 'PATCH',
      token: token,
      body: input,
    );
  }

  Future<void> updateDroneStatus(String token, String id, String status) async {
    await request(
      '/fleet/drones/$id/status',
      method: 'PATCH',
      token: token,
      body: {'status': status},
    );
  }

  Future<ServicePage> fetchServices(
    String token, {
    required int page,
    required int pageSize,
    required String search,
    String? category,
    String? status,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (search.isNotEmpty) 'search': search,
      if (category != null && category.isNotEmpty) 'category': category,
      if (status != null && status.isNotEmpty) 'status': status,
    };
    final path = Uri(path: '/services', queryParameters: params).toString();
    final data = await request(path, token: token);
    return ServicePage.fromJson(data);
  }

  Future<void> createService(String token, Map<String, Object?> input) async {
    await request('/services', method: 'POST', token: token, body: input);
  }

  Future<void> updateService(
    String token,
    String id,
    Map<String, Object?> input,
  ) async {
    await request('/services/$id', method: 'PATCH', token: token, body: input);
  }

  Future<void> updateServiceStatus(
    String token,
    String id,
    String status,
  ) async {
    await request(
      '/services/$id/status',
      method: 'PATCH',
      token: token,
      body: {'status': status},
    );
  }

  Future<RequestPage> fetchRequests(
    String token, {
    required int page,
    required int pageSize,
    required String search,
    String? status,
    String? urgency,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
      if (urgency != null && urgency.isNotEmpty) 'urgency': urgency,
    };
    final path = Uri(path: '/requests', queryParameters: params).toString();
    final data = await request(path, token: token);
    return RequestPage.fromJson(data);
  }

  Future<void> createRequest(String token, Map<String, Object?> input) async {
    await request('/requests', method: 'POST', token: token, body: input);
  }

  Future<void> updateRequest(
    String token,
    String id,
    Map<String, Object?> input,
  ) async {
    await request('/requests/$id', method: 'PATCH', token: token, body: input);
  }

  Future<void> updateRequestStatus(
    String token,
    String id,
    String status,
  ) async {
    await request(
      '/requests/$id/status',
      method: 'PATCH',
      token: token,
      body: {'status': status},
    );
  }

  Future<dynamic> request(
    String path, {
    String method = 'GET',
    String? token,
    Map<String, Object?>? body,
  }) async {
    final uri = Uri.parse('$apiBaseUrl$path');
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 12);

    try {
      final request = await client.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      if (token != null) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseText = await response.transform(utf8.decoder).join();
      final decoded = responseText.isEmpty ? null : jsonDecode(responseText);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded is Map<String, dynamic>
            ? decoded['message']
            : null;
        throw Exception(message ?? 'Request failed');
      }

      return decoded;
    } on SocketException {
      throw Exception('Unable to reach API server.');
    } finally {
      client.close(force: true);
    }
  }
}
