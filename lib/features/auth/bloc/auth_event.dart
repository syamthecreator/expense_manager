import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends AuthEvent {
  final String phone;

  const PhoneNumberChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SubmitPhoneNumber extends AuthEvent {}

class OtpChanged extends AuthEvent {
  final String otp;

  const OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtp extends AuthEvent {}

class ResendOtp extends AuthEvent {}

class SubmitNickname extends AuthEvent {
  final String nickname;
  const SubmitNickname(this.nickname);

  @override
  List<Object?> get props => [nickname];
}