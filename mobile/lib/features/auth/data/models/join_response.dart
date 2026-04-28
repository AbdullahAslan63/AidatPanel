import '../../../auth/domain/entities/user_entity.dart';

class JoinResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  JoinResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory JoinResponse.fromJson(Map<String, dynamic> json) {
    return JoinResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final String language;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    this.language = 'en',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      language: json['language'] as String? ?? 'en',
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      phone: phone,
      role: role == 'MANAGER' ? UserRole.manager : UserRole.resident,
      language: language,
    );
  }
}
