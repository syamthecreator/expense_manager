import 'package:expense_manager/features/auth/data/auth_api_service.dart';
import 'package:expense_manager/features/auth/data/auth_repository.dart';

final authRepository = AuthRepository(AuthApiService());