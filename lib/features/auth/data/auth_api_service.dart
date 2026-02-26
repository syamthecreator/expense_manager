import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/core/network/api_config.dart';
import 'package:http/http.dart' as http;

/// Handles all authentication-related API calls
class AuthApiService {
  // Base URL for auth APIs

  /// Sends OTP to the given phone number
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/send-otp/');

    // Log request details (useful for debugging)
    log('SEND OTP REQUEST');
    log('URL: $url');
    log('BODY: { phone: $phone }');

    try {
      // Make POST request to send OTP
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      // Log response details
      log('SEND OTP RESPONSE');
      log('STATUS: ${response.statusCode}');
      log('BODY: ${response.body}');

      // Handle non-success response
      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP');
      }

      // Decode and return response body
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e, s) {
      // Log error with stack trace
      log('SEND OTP API ERROR', error: e, stackTrace: s);

      // Rethrow so Bloc can handle UI state
      rethrow;
    }
  }

  /// Creates a new account using phone number and nickname
  Future<String> createAccount({
    required String phone,
    required String nickname,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/create-account/');

    // Log request details
    log('CREATE ACCOUNT REQUEST');
    log('URL: $url');
    log('BODY: { phone: $phone, nickname: $nickname }');

    try {
      // Make POST request to create account
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'nickname': nickname}),
      );

      // Log response details
      log('CREATE ACCOUNT RESPONSE');
      log('STATUS: ${response.statusCode}');
      log('BODY: ${response.body}');

      // Handle API failure
      if (response.statusCode != 200) {
        throw Exception('Account creation failed');
      }

      // Decode response body
      final decoded = jsonDecode(response.body);

      // Validate token existence
      if (decoded['token'] == null) {
        throw Exception('Token missing in response');
      }

      // Return auth token
      return decoded['token'] as String;
    } catch (e, s) {
      // Log error with stack trace
      log('CREATE ACCOUNT API ERROR', error: e, stackTrace: s);

      // Rethrow to let Bloc handle error UI
      rethrow;
    }
  }
}
