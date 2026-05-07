class RegisterResponse {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;

  RegisterResponse({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['user'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
    );
  }
}
