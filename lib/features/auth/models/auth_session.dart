class AuthSession {
  AuthSession({required this.token, required this.user});

  final String token;
  final AuthUser user;

  factory AuthSession.fromJson(dynamic json) {
    return AuthSession(
      token: json['token'] as String,
      user: AuthUser.fromJson(json['user']),
    );
  }

  Map<String, Object?> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}

class AuthUser {
  AuthUser({required this.name, required this.email, required this.role});

  final String name;
  final String email;
  final String role;

  factory AuthUser.fromJson(dynamic json) {
    return AuthUser(
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'org_owner',
    );
  }

  Map<String, Object?> toJson() {
    return {'name': name, 'email': email, 'role': role};
  }
}
