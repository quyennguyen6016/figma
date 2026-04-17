import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  static const String _baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  String? _accessToken;
  User? _currentUser;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> initialize() async {}

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      _accessToken = (body['access'] ?? body['token']) as String?;

      final userJson = body['user'] is Map<String, dynamic>
          ? body['user'] as Map<String, dynamic>
          : body;
      _currentUser = User.fromJson(_normalizeUserJson(userJson));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password,
    String role,
    String fullName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': role,
          'full_name': fullName,
        }),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    if (_accessToken == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/me/'),
        headers: _authorizedJsonHeaders(),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      _currentUser = User.fromJson(_normalizeUserJson(body));
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<User?> updateCurrentUser(Map<String, dynamic> payload) async {
    if (_accessToken == null) return null;

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/auth/me/'),
        headers: _authorizedJsonHeaders(),
        body: jsonEncode(payload),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      _currentUser = User.fromJson(_normalizeUserJson(body));
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    final token = _accessToken;
    _accessToken = null;
    _currentUser = null;

    if (token == null) return;

    try {
      await http.post(
        Uri.parse('$_baseUrl/api/auth/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {}
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/'),
        headers: _authorizedJsonHeaders(),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return [];
      }

      final decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List<dynamic>
          ? decoded
          : (decoded['results'] as List<dynamic>? ?? <dynamic>[]);

      return list
          .map((userJson) {
            try {
              return User.fromJson(
                _normalizeUserJson(userJson as Map<String, dynamic>),
              );
            } catch (_) {
              return null;
            }
          })
          .whereType<User>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Map<String, String> _authorizedJsonHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  Map<String, String> authorizedJsonHeaders() {
    return _authorizedJsonHeaders();
  }

  Map<String, dynamic> _normalizeUserJson(Map<String, dynamic> json) {
    return {
      'username': json['username']?.toString() ?? '',
      'password': json['password']?.toString() ?? '',
      'role': json['role']?.toString() ?? 'patient',
      'fullName': (json['fullName'] ?? json['full_name'] ?? '').toString(),
      'dateOfBirth':
          (json['dateOfBirth'] ?? json['date_of_birth'] ?? '').toString(),
      'gender': json['gender']?.toString() ?? '',
      'phoneNumber':
          (json['phoneNumber'] ?? json['phone_number'] ?? '').toString(),
      'insuranceNumber':
          (json['insuranceNumber'] ?? json['insurance_number'] ?? '').toString(),
      'address': json['address']?.toString() ?? '',
    };
  }
}
