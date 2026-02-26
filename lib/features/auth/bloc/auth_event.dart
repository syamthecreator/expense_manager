import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends AuthEvent {
  final String phone;
  const PhoneNumberChanged(this.phone);
}

class SubmitPhoneNumber extends AuthEvent {
  const SubmitPhoneNumber();
}

class OtpChanged extends AuthEvent {
  final String otp;
  const OtpChanged(this.otp);
}

class VerifyOtp extends AuthEvent {
  const VerifyOtp();
}

class ClearOtp extends AuthEvent {
  const ClearOtp();
}

class SubmitNickname extends AuthEvent {
  final String nickname;
  const SubmitNickname(this.nickname);
}

class UpdateNickname extends AuthEvent {
  final String nickname;
  const UpdateNickname(this.nickname);
}

class LoadSession extends AuthEvent {
  const LoadSession();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}