import 'package:expense_manager/features/auth/data/auth_api_service.dart';
import 'package:expense_manager/features/auth/data/auth_repository.dart';
import 'package:expense_manager/features/categories/data/category_repository.dart';
import 'package:expense_manager/features/categories/service/category_remote_service.dart';

// Handles authentication logic and API calls
final authRepository = AuthRepository(AuthApiService());
// Manages local category data
final categoryRepository = CategoryRepository();
// Handles remote category API operations
final categoryRemoteService = CategoryRemoteService();
