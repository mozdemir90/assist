import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      final response = await _apiClient.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];

        await _storage.write(key: 'jwt_token', value: token);
        return User.fromJson(userData);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
         throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
         throw Exception('Hatalı e-posta veya şifre');
      }
      throw Exception(e.response?.data['message'] ?? 'Giriş işlemi başarısız oldu.');
    } catch (e) {
      throw Exception('Beklenmedik bir hata oluştu.');
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
         throw Exception('İnternet bağlantısı yok, çevrimdışı çalışılıyor');
      }
      if (e.response?.statusCode == 400) {
         throw Exception(e.response?.data['message'] ?? 'Kayıt bilgileri geçersiz.');
      }
      throw Exception('Kayıt işlemi başarısız oldu.');
    } catch (e) {
      throw Exception('Kayıt işlemi sırasında beklenmedik bir hata oluştu.');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(apiClient, storage);
}
