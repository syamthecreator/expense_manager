import 'package:equatable/equatable.dart';
enum AuthStatus {
  initial,
  sendingOtp,
  otpSent,
  verifying,
  needsNickname,
  authenticated,
  error,
}

class AuthState extends Equatable {
  final String phone;
  final String otp;
  final String? apiOtp;
  final bool userExists;
  final String? nickname;
  final String? token;
  final AuthStatus status;
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
  List<Object?> get props =>
      [phone, otp, apiOtp, userExists, nickname, token, status, errorMessage];
}