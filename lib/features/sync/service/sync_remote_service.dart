import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

/// Remote service for sync-related APIs
class SyncRemoteService {
  /// Sync new categories to server
  Future<List<String>> syncCategories({
    required String token,
    required List<Map<String, dynamic>> categories,
  }) async {
    if (categories.isEmpty) return [];

    final uri = Uri.parse('${ApiConfig.baseUrl}/categories/add/');
    log('[SYNC] POST -> $uri');
    log('Categories payload: $categories');

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
      throw Exception('Category sync failed');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['synced_ids']);
  }

  /// Delete categories from server
  Future<List<String>> deleteCategories({
    required String token,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) return [];

    final uri = Uri.parse('${ApiConfig.baseUrl}/categories/delete/');
    log('[SYNC] POST -> $uri');
    log('Category delete IDs: $ids');

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
      throw Exception('Category delete failed');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['deleted_ids']);
  }

 /// Sync new transactions to server
Future<List<String>> syncTransactions({
  required String token,
  required List<Map<String, dynamic>> transactions,
}) async {
  if (transactions.isEmpty) return [];

  final uri = Uri.parse('${ApiConfig.baseUrl}/transactions/add/');
  log('[SYNC] POST -> $uri');
  log('Transactions payload: $transactions');

  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'transactions': transactions}),
  );

  log('Status: ${response.statusCode}');
  log('Body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Transaction sync failed');
  }

  final Map<String, dynamic> json = jsonDecode(response.body);

  final List<dynamic> syncedTransactions = json['transactions'] ?? [];

  /// Extract IDs safely
  return syncedTransactions
      .map((e) => e['id']?.toString())
      .whereType<String>()
      .toList();
}
  /// Delete transactions from server
 Future<List<String>> deleteTransactions({
  required String token,
  required List<String> ids,
}) async {
  if (ids.isEmpty) return [];

  final uri = Uri.parse('${ApiConfig.baseUrl}/transactions/delete/');
  log('[SYNC] DELETE -> $uri');
  log('Transaction delete IDs: $ids');

  final response = await http.delete(
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
    throw Exception('Transaction delete failed');
  }

  final json = jsonDecode(response.body);
  return List<String>.from(json['deleted_ids']);
}
}
