import 'auth_api_service.dart';

class AuthRepository {
  final AuthApiService api;

  AuthRepository(this.api);

  Future<Map<String, dynamic>> sendOtp(String phone) {
    return api.sendOtp(phone);
  }

  Future<String> createAccount(String phone, String nickname) {
    return api.createAccount(phone: phone, nickname: nickname);
  }
}