import 'package:equatable/equatable.dart';

/// Represents the current authentication step/status
enum AuthStatus {
  initial, // Initial state (nothing started)
  sendingOtp, // OTP API call in progress
  otpSent, // OTP successfully sent
  verifying, // Verifying OTP / creating account
  needsNickname, // New user needs to enter nickname
  authenticated, // User successfully logged in
  error, // Any error state
}

/// Holds all authentication-related data
class AuthState extends Equatable {
  // Entered phone number
  final String phone;

  // OTP entered by user
  final String otp;

  // OTP received from API (for validation)
  final String? apiOtp;

  // Whether user already exists in backend
  final bool userExists;

  // User nickname (existing or newly created)
  final String? nickname;

  // Auth token returned from API
  final String? token;

  // Current authentication status
  final AuthStatus status;

  // Error message to show in UI
  final String? errorMessage;

  const AuthState({
    this.phone = '',
    this.otp = '',
    this.apiOtp,
    this.userExists = false,
    this.nickname,
    this.token,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  /// Only provided fields will be replaced
  AuthState copyWith({
    String? phone,
    String? otp,
    String? apiOtp,
    bool? userExists,
    String? nickname,
    String? token,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      apiOtp: apiOtp ?? this.apiOtp,
      userExists: userExists ?? this.userExists,
      nickname: nickname ?? this.nickname,
      token: token ?? this.token,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    phone,
    otp,
    apiOtp,
    userExists,
    nickname,
    token,
    status,
    errorMessage,
  ];
}
