import 'dart:convert';

import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/join_request.dart';
import '../models/user_data.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(
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
      // FIX: Tüm kullanıcı detaylarını JSON olarak sakla
      await _secureStorage.saveUser(jsonEncode(response.user));
      await _secureStorage.saveTokenExpiry(
        DateTime.now().add(const Duration(minutes: 15)),
      );

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Giriş sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    String name,
    String? phone,
  ) async {
    try {
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      await _remoteDataSource.register(registerRequest);

      // Backend register token döndürmüyor — otomatik login yap
      final loginRequest = LoginRequest(email: email, password: password);
      final loginResponse = await _remoteDataSource.login(loginRequest);

      await _secureStorage.saveToken(loginResponse.accessToken);
      await _secureStorage.saveRefreshToken(loginResponse.refreshToken);
      await _secureStorage.saveUser(jsonEncode(loginResponse.user));
      await _secureStorage.saveTokenExpiry(
        DateTime.now().add(const Duration(minutes: 15)),
      );

      return loginResponse.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Kayıt sırasında bir hata oluştu: $e');
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
      // FIX: Tüm kullanıcı detaylarını JSON olarak sakla
      await _secureStorage.saveUser(jsonEncode(response.user));
      await _secureStorage.saveTokenExpiry(
        DateTime.now().add(const Duration(minutes: 15)),
      );

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Katılım sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  @override
  Future<UserEntity?> getStoredUser() async {
    final userJson = await _secureStorage.getUser();
    if (userJson == null) return null;

    try {
      // FIX: JSON'dan tüm kullanıcı detaylarını parse et
      final userData = UserData.fromJson(jsonDecode(userJson));
      return userData.toEntity();
    } catch (e) {
      // Eski format (sadece ID) varsa temizle
      await _secureStorage.clearAll();
      return null;
    }
  }
}
