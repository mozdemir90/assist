import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepository(this._apiClient, this._storage);

  Future<User?> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];
        print(
          "LOGIN SUCCESS: user=${userData['username']}, token=${token.substring(0, 10)}...",
        );

        await _storage.write(key: 'jwt_token', value: token);
        print('userData keys: ${userData.keys}');
        print(
          "is_active value: ${userData['is_active']} (type: ${userData['is_active'].runtimeType})",
        );
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
      print(
        'LOGIN ERROR (Dio): ${e.response?.statusCode} - ${e.response?.data}',
      );
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        throw Exception('Hatalı e-posta veya şifre');
      }
      throw Exception(
        e.response?.data['message'] ?? 'Giriş işlemi başarısız oldu.',
      );
    } catch (e) {
      print('LOGIN ERROR (Unexpected): $e');
      throw Exception('Beklenmedik bir hata oluştu.');
    }
  }

  Future<User?> register(String username, String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        // Auto-login after register is a common UX pattern
        return await login(username, password);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Kayıt bilgileri geçersiz.',
        );
      }
      throw Exception('Kayıt işlemi başarısız oldu.');
    } catch (e) {
      throw Exception('Kayıt işlemi sırasında beklenmedik bir hata oluştu.');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<void> updateFcmToken(String? fcmToken) async {
    try {
      await _apiClient.dio.post(
        '/auth/fcm-token',
        data: {'fcm_token': fcmToken},
      );
      print('FCM Token updated successfully to backend.');
    } catch (e) {
      print('Failed to update FCM Token to backend: $e');
      // Non-critical, so we catch and log rather than throw
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

<<<<<<< HEAD
  Future<User?> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Failed to get profile: $e');
      return null;
    }
  }

=======
>>>>>>> feature/push-notifications-auth
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Şifre sıfırlama talebi başarısız oldu.');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('İnternet bağlantısı yok.');
      }
      throw Exception(
        e.response?.data['message'] ?? 'Şifre sıfırlama talebi başarısız oldu.',
      );
    } catch (e) {
      throw Exception('Beklenmedik bir hata oluştu.');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/reset-password',
        data: {'token': token, 'new_password': newPassword},
      );

      if (response.statusCode != 200) {
        throw Exception('Şifre sıfırlama işlemi başarısız oldu.');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('İnternet bağlantısı yok.');
      }
      throw Exception(
        e.response?.data['message'] ?? 'Şifre sıfırlama işlemi başarısız oldu.',
      );
    } catch (e) {
      throw Exception('Beklenmedik bir hata oluştu.');
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(apiClient, storage);
}
