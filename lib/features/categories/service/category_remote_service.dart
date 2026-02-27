import 'dart:convert';
import 'dart:developer';

import 'package:expense_manager/core/constants/api_config.dart';
import 'package:expense_manager/features/categories/model/category_model.dart';
import 'package:http/http.dart' as http;

/// Remote service for category APIs
class CategoryRemoteService {

  /// Fetches categories from server
  Future<List<CategoryModel>> fetchCategories(String token) async {
    log('[CategoryRemoteService] Fetch categories started');

    final uri = Uri.parse('${ApiConfig.baseUrl}/categories/');
    log('GET -> $uri');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch categories');
    }

    final json = jsonDecode(response.body);
    final list = json['categories'] as List;

    return list
        .map((e) => CategoryModel(id: e['id'], name: e['name'], isSynced: true))
        .toList();
  }

  /// Adds categories to server
  Future<List<String>> addCategories({
    required String token,
    required List<Map<String, dynamic>> categories,
  }) async {
    if (categories.isEmpty) return [];

    final uri = Uri.parse('${ApiConfig.baseUrl}/categories/add/');
    log('POST -> $uri');
    log('Payload: $categories');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'categories': categories}),
    );

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to sync categories');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['synced_ids']);
  }

  /// Deletes categories from server
  Future<List<String>> deleteCategories({
    required String token,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) return [];

    final uri = Uri.parse('${ApiConfig.baseUrl}/categories/delete/');
    log('POST -> $uri');
    log('Delete IDs: $ids');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'ids': ids}),
    );

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete categories');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['deleted_ids']);
  }
}
