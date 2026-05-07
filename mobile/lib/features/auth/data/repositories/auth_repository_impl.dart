import 'dart:convert';

import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/join_request.dart';
import '../models/user_data.dart';

DateTime _parseJwtExpiry(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return DateTime.now().add(const Duration(minutes: 15));
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    final data = jsonDecode(decoded) as Map<String, dynamic>;
    final exp = data['exp'] as int?;
    if (exp == null) return DateTime.now().add(const Duration(minutes: 15));
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  } catch (_) {
    return DateTime.now().add(const Duration(minutes: 15));
  }
}

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> register(
    String email,
    String password,
    String name,
    String? phone,
  );
  Future<UserEntity> join(
    String inviteCode,
    String email,
    String password,
    String name,
    String? phone,
  );
  Future<void> logout();
  Future<UserEntity?> getStoredUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorage = secureStorage;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);

      await _secureStorage.saveToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUser(jsonEncode(response.user.toJson()));
      await _secureStorage.saveTokenExpiry(_parseJwtExpiry(response.accessToken));

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(message: 'Giriş sırasında bir hata oluştu');
    }
  }

  @override
  Future<void> register(
    String email,
    String password,
    String name,
    String? phone,
  ) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      await _remoteDataSource.register(request);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(message: 'Kayıt sırasında bir hata oluştu');
    }
  }

  @override
  Future<UserEntity> join(
    String inviteCode,
    String email,
    String password,
    String name,
    String? phone,
  ) async {
    try {
      final request = JoinRequest(
        inviteCode: inviteCode,
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      final response = await _remoteDataSource.join(request);

      await _secureStorage.saveToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUser(jsonEncode(response.user.toJson()));
      await _secureStorage.saveTokenExpiry(_parseJwtExpiry(response.accessToken));

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(message: 'Katılım sırasında bir hata oluştu');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAuth();
  }

  @override
  Future<UserEntity?> getStoredUser() async {
    final userJson = await _secureStorage.getUser();
    if (userJson == null) return null;

    try {
      final userData = UserData.fromJson(jsonDecode(userJson));
      return userData.toEntity();
    } catch (_) {
      await _secureStorage.clearAll();
      return null;
    }
  }
}
