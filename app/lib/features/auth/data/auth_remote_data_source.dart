import 'package:dio/dio.dart';

import '../domain/entities/session.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Session> login(String email, String password) {
    return _session('/auth/login', {'email': email, 'password': password});
  }

  Future<Session> register(String name, String email, String password) {
    return _session('/auth/register', {'name': name, 'email': email, 'password': password});
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post<void>('/auth/logout', data: {'refreshToken': refreshToken});
  }

  Future<Session> _session(String path, Map<String, String> body) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: body);
    final data = response.data!;
    return Session(
      user: AppUser.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}
