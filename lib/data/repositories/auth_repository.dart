import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/auth_response_model.dart';

class AuthRepository {
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return AuthResponseModel.fromJson(json.decode(response.body));
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return AuthResponseModel.fromJson(json.decode(response.body));
  }
}
