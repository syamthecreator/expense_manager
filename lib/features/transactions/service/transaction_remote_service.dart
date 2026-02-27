import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

/// Remote service for transaction APIs
class TransactionRemoteService {
  /// Adds transactions to the server
  Future<List<String>> addTransactions({
    required String token,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/transactions/add/');
    log('POST -> $uri');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'transactions': transactions}),
    );

    log('${response.statusCode} -> ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to sync transactions');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['synced_ids']);
  }

  /// Deletes transactions from the server
  Future<List<String>> deleteTransactions({
    required String token,
    required List<String> ids,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/transactions/delete/');
    log('POST -> $uri');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'ids': ids}),
    );

    log('${response.statusCode} -> ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transactions');
    }

    final json = jsonDecode(response.body);
    return List<String>.from(json['deleted_ids']);
  }
}
