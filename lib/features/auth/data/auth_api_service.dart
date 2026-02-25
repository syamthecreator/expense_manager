import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const _baseUrl = 'https://appskilltest.zybotech.in';

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse('$_baseUrl/auth/send-otp/');

    log('SEND OTP REQUEST');
    log('URL: $url');
    log('BODY: { phone: $phone }');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    log('SEND OTP RESPONSE');
    log('STATUS: ${response.statusCode}');
    log('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }

    return jsonDecode(response.body);
  }

  Future<String> createAccount({
    required String phone,
    required String nickname,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/create-account/');

    log('CREATE ACCOUNT REQUEST');
    log('URL: $url');
    log('BODY: { phone: $phone, nickname: $nickname }');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'nickname': nickname}),
    );

    log('CREATE ACCOUNT RESPONSE');
    log('STATUS: ${response.statusCode}');
    log('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Account creation failed');
    }

    return jsonDecode(response.body)['token'];
  }
}
