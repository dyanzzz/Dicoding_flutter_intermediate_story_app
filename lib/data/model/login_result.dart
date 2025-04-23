class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> map) {
    return LoginResult(
      userId: map["userId"] ?? '',
      name: map["name"] ?? '',
      token: map["token"] ?? '',
    );
  }
}
