import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'api_client.g.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({required Dio dio, required FlutterSecureStorage storage})
      : _dio = dio,
        _storage = storage {
    _dio.options.baseUrl = _getBaseUrl();
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 && e.response?.data?['code'] == 'token_expired') {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                // Important: Use a new Dio instance to avoid interceptor loops
                final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
                final response = await refreshDio.post('/auth/refresh', data: {
                  'refresh_token': refreshToken
                });
                if (response.statusCode == 200) {
                  final newAccessToken = response.data['token'];
                  final newRefreshToken = response.data['refresh_token'];
                  await _storage.write(key: 'jwt_token', value: newAccessToken);
                  await _storage.write(key: 'refresh_token', value: newRefreshToken);

                  // Retry original request with new token
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  final retryResponse = await _dio.fetch(e.requestOptions);
                  return handler.resolve(retryResponse);
                }
              } catch (_) {
                // Refresh failed, clear tokens and let the 401 propagate
                await _storage.delete(key: 'jwt_token');
                await _storage.delete(key: 'refresh_token');
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  String _getBaseUrl() {
    // For local development on emulator/simulator
    if (kIsWeb) return 'http://127.0.0.1:5000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api'; // Android Emulator alias for localhost
    }
    return 'http://127.0.0.1:5000/api'; // iOS Simulator / Desktop
  }

  Dio get dio => _dio;
}

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(dio: Dio(), storage: storage);
}
