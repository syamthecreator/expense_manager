import 'auth_api_service.dart';

/// Repository layer that connects Bloc with API service
class AuthRepository {
  // Auth API service dependency
  final AuthApiService api;

  AuthRepository(this.api);

  /// Sends OTP to the given phone number
  /// Delegates API call to AuthApiService
  Future<Map<String, dynamic>> sendOtp(String phone) {
    return api.sendOtp(phone);
  }

  /// Creates a new account and returns auth token
  /// Delegates API call to AuthApiService
  Future<String> createAccount(String phone, String nickname) {
    return api.createAccount(
      phone: phone,
      nickname: nickname,
    );
  }
}