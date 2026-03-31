import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
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
      ),
    );
  }

  String _getBaseUrl() {
    // Point to Render deployed backend
    return 'https://assist-ps2h.onrender.com/api';
  }

  Dio get dio => _dio;
}

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

@riverpod
ApiClient apiClient(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(dio: Dio(), storage: storage);
}
