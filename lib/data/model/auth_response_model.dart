import 'login_result.dart';

class AuthResponseModel {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  AuthResponseModel({
    required this.error,
    required this.message,
    this.loginResult,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> map) {
    return AuthResponseModel(
      error: map["error"] ?? false,
      message: map["message"] ?? '',
      loginResult:
          map["loginResult"] == null
              ? null
              : LoginResult.fromJson(map["loginResult"]),
    );
  }
}
