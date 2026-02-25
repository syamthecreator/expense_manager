import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(const AuthState()) {
    on<PhoneNumberChanged>(_onPhoneChanged);
    on<SubmitPhoneNumber>(_onSubmitPhone);
    on<OtpChanged>(_onOtpChanged);
    on<VerifyOtp>(_onVerifyOtp);
    on<SubmitNickname>(_onSubmitNickname);
  }

  void _onPhoneChanged(PhoneNumberChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(phone: e.phone));
  }

  Future<void> _onSubmitPhone(
  SubmitPhoneNumber event,
  Emitter<AuthState> emit,
) async {
  log('SUBMIT PHONE EVENT');
  log('PHONE: ${state.phone}');

  emit(state.copyWith(status: AuthStatus.sendingOtp));
  log('⏳ STATE → sendingOtp');

  try {
    final phone = state.phone.startsWith('+91')
        ? state.phone
        : '+91${state.phone}';

    final res = await repository.sendOtp(phone);

    log('OTP API SUCCESS');
    log('OTP: ${res['otp']}');
    log('USER EXISTS: ${res['user_exists']}');
    log('TOKEN: ${res['token']}');

    emit(state.copyWith(
      status: AuthStatus.otpSent,
      apiOtp: res['otp'],
      userExists: res['user_exists'],
      nickname: res['nickname'],
      token: res['token'],
    ));

    log('STATE → otpSent');
  } catch (e) {
    log('OTP ERROR: $e');

    emit(state.copyWith(
      status: AuthStatus.error,
      errorMessage: e.toString(),
    ));
  }
}

  void _onOtpChanged(OtpChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(otp: e.otp));
  }

  Future<void> _onVerifyOtp(
      VerifyOtp e, Emitter<AuthState> emit) async {
    if (state.otp != state.apiOtp) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid OTP',
      ));
      return;
    }

    if (state.userExists) {
      await _saveSession(state.token!, state.nickname!);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.needsNickname));
    }
  }

  Future<void> _onSubmitNickname(
      SubmitNickname e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.verifying));

    final token =
        await repository.createAccount('+91${state.phone}', e.nickname);

    await _saveSession(token, e.nickname);

    emit(state.copyWith(status: AuthStatus.authenticated));
  }

  Future<void> _saveSession(String token, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('nickname', nickname);
  }
}