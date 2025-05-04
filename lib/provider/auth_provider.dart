import 'package:dicoding_story_flutter/screens/widgets/overlay_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository.dart';
import '../data/model/login_result.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  String _errorMessage = '';
  LoginResult? _loginResult;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  LoginResult? get loginResult => _loginResult;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      if (response.error) {
        OverlaySnackbar.warning(context, response.message);
        _errorMessage = response.message;
        return false;
      } else {
        OverlaySnackbar.success(context, response.message);
        _errorMessage = '';
        return !response.error;
      }
    } catch (e) {
      OverlaySnackbar.error(context, e.toString());
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      if (!response.error && response.loginResult != null) {
        OverlaySnackbar.success(context, response.message);
        _loginResult = response.loginResult;
        await _saveAuthData(response.loginResult!);
        _errorMessage = '';
        return !response.error;
      } else {
        OverlaySnackbar.warning(context, response.message);
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      OverlaySnackbar.error(context, e.toString());
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveAuthData(LoginResult loginResult) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', loginResult.token);
    await prefs.setString('userId', loginResult.userId);
    await prefs.setString('name', loginResult.name);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loginResult = null;
    notifyListeners();
  }
}
