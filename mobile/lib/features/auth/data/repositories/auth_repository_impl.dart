import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/join_request.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String name, String? phone);
  Future<UserEntity> join(String inviteCode, String password, String name, String? phone);
  Future<void> logout();
  Future<UserEntity?> getStoredUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);

      await _secureStorage.saveToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUser(response.user.id);

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Giriş sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String name, String? phone) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      final response = await _remoteDataSource.register(request);

      await _secureStorage.saveToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUser(response.user.id);

      return response.user.toEntity();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Kayıt sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<UserEntity> join(String inviteCode, String password, String name, String? phone) async {
    try {
      final request = JoinRequest(
        inviteCode: inviteCode,
        password: password,
        name: name,
        phone: phone,
      );
      final response = await _remoteDataSource.join(request);

      await _secureStorage.saveToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUser(response.user.id);

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
    final userId = await _secureStorage.getUser();
    return userId != null ? UserEntity(id: userId, email: '', name: '', role: UserRole.resident) : null;
  }
}
