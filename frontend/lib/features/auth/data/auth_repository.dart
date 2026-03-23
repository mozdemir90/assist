import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
<<<<<<< Updated upstream
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
=======
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/error/exceptions.dart';
>>>>>>> Stashed changes
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepository(this._apiClient, this._storage);

  Future<User?> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
<<<<<<< Updated upstream
        final userData = response.data['user'];
        print("LOGIN SUCCESS: user=${userData['username']}, token=${token.substring(0, 10)}...");

        await _storage.write(key: 'jwt_token', value: token);
        print('userData keys: ${userData.keys}');
        print("is_active value: ${userData['is_active']} (type: ${userData['is_active'].runtimeType})");
        try {
          final user = User.fromJson(userData);
          print('User.fromJson successful: ${user.username}');
          return user;
        } catch (e) {
          print('User.fromJson FAILED: $e');
          rethrow;
        }
      }
      print('LOGIN FAILED: Unknown reason');
      return null;
    } on DioException catch (e) {
      print('LOGIN ERROR (Dio): ${e.response?.statusCode} - ${e.response?.data}');
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
         throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
         throw Exception('Hatalı e-posta veya şifre');
      }
      throw Exception(e.response?.data['message'] ?? 'Giriş işlemi başarısız oldu.');
    } catch (e) {
      print('LOGIN ERROR (Unexpected): $e');
      throw Exception('Beklenmedik bir hata oluştu.');
=======
        final refreshToken = response.data['refresh_token'];
        final userData = response.data['user'];

        await _storage.write(key: 'jwt_token', value: token);
        if (refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: refreshToken);
        }
        return User.fromJson(userData);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
         appLogger.w('Login connection error: \${e.message}');
         throw NetworkException('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
         appLogger.w('Login auth error: \${e.response?.statusCode}');
         throw AuthException('Hatalı e-posta veya şifre');
      }
      appLogger.e('Login failed with dio exception: \${e.message}');
      throw CustomAppException(e.response?.data['message'] ?? 'Giriş işlemi başarısız oldu.');
    } catch (e, st) {
      appLogger.e('Unexpected login error', error: e, stackTrace: st);
      throw CustomAppException('Beklenmedik bir hata oluştu.');
>>>>>>> Stashed changes
    }
  }

  Future<User?> register(String username, String email, String password) async {
     try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        // Auto-login after register is a common UX pattern
        return await login(username, password);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
<<<<<<< Updated upstream
         throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 400) {
         throw Exception(e.response?.data['message'] ?? 'Kayıt bilgileri geçersiz.');
      }
      throw Exception('Kayıt işlemi başarısız oldu.');
    } catch (e) {
      throw Exception('Kayıt işlemi sırasında beklenmedik bir hata oluştu.');
=======
         appLogger.w('Register connection error: \${e.message}');
         throw NetworkException('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 400) {
         appLogger.w('Register validation error: \${e.response?.data}');
         throw AuthException(e.response?.data['message'] ?? 'Kayıt bilgileri geçersiz.');
      }
      appLogger.e('Register failed with dio exception: \${e.message}');
      throw CustomAppException('Kayıt işlemi başarısız oldu.');
    } catch (e, st) {
      appLogger.e('Unexpected register error', error: e, stackTrace: st);
      throw CustomAppException('Kayıt işlemi sırasında beklenmedik bir hata oluştu.');
>>>>>>> Stashed changes
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
<<<<<<< Updated upstream
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
=======
    await _storage.delete(key: 'refresh_token');
  }

  Future<User?> checkAuth() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _apiClient.dio.get('/auth/me');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
         appLogger.w('Initial auth check offline - allowing local cached auth');
         // Offline fallback: if token exists, we allow them in. Full verification will happen when online
         return const User(id: 'offline_user', username: 'Offline User', email: '', isActive: true);
      }
      // Token is invalid/expired and refresh failed (handled by interceptor)
      appLogger.i('Token invalid/expired during checkAuth');
      await logout();
      return null;
    } catch (e) {
      appLogger.e('Unexpected error during checkAuth', error: e);
      return null;
    }
>>>>>>> Stashed changes
  }
}

@riverpod
<<<<<<< Updated upstream
AuthRepository authRepository(Ref ref) {
=======
AuthRepository authRepository(AuthRepositoryRef ref) {
>>>>>>> Stashed changes
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(apiClient, storage);
}
