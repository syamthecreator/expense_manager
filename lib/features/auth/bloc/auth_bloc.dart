
import 'package:expense_manager/features/categories/data/category_repository.dart';
import 'package:expense_manager/features/categories/service/category_remote_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final CategoryRepository categoryRepository;
  final CategoryRemoteService categoryRemoteService;

  AuthBloc({
    required this.repository,
    required this.categoryRepository,
    required this.categoryRemoteService,
  }) : super(const AuthState()) {
    // REGISTER ALL EVENT
    on<PhoneNumberChanged>(_onPhoneChanged);
    on<SubmitPhoneNumber>(_onSubmitPhone);
    on<OtpChanged>(_onOtpChanged);
    on<VerifyOtp>(_onVerifyOtp);
    on<SubmitNickname>(_onSubmitNickname);
    on<UpdateNickname>(_onUpdateNickname); 
    on<LoadSession>(_onLoadSession);      
    on<ClearOtp>(_onClearOtp);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onPhoneChanged(PhoneNumberChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(phone: e.phone));
  }

  Future<void> _onSubmitPhone(
    SubmitPhoneNumber event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.sendingOtp));

    try {
      final phone =
          state.phone.startsWith('+91') ? state.phone : '+91${state.phone}';

      final response = await repository.sendOtp(phone);

      emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          apiOtp: response['otp'],
          userExists: response['user_exists'],
          nickname: response['nickname'],
          token: response['token'],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onOtpChanged(OtpChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(otp: e.otp));
  }

  Future<void> _onVerifyOtp(
    VerifyOtp e,
    Emitter<AuthState> emit,
  ) async {
    if (state.otp != state.apiOtp) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP',
        ),
      );
      return;
    }

    if (state.userExists) {
      await _saveSession(state.token!, state.nickname!);

      final categories =
          await categoryRemoteService.fetchCategories(state.token!);
      await categoryRepository.insertFromApi(categories);

      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.needsNickname));
    }
  }

  Future<void> _onSubmitNickname(
    SubmitNickname e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.verifying));

    final token = await repository.createAccount(
      '+91${state.phone}',
      e.nickname,
    );

    await _saveSession(token, e.nickname);

    final categories = await categoryRemoteService.fetchCategories(token);
    await categoryRepository.insertFromApi(categories);

    emit(
      state.copyWith(
        token: token,
        nickname: e.nickname,
        status: AuthStatus.authenticated,
      ),
    );
  }

  // UPDATE NICKNAME
  Future<void> _onUpdateNickname(
    UpdateNickname e,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', e.nickname);

    emit(state.copyWith(nickname: e.nickname));
  }

  // LOAD SESSION ON APP START
  Future<void> _onLoadSession(
    LoadSession event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final nickname = prefs.getString('nickname');

    if (token != null && nickname != null) {
      emit(
        state.copyWith(
          token: token,
          nickname: nickname,
          status: AuthStatus.authenticated,
        ),
      );
    }
  }

  void _onClearOtp(ClearOtp event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        otp: '',
        apiOtp: null,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(const AuthState());
  }

  Future<void> _saveSession(String token, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('nickname', nickname);
  }
}