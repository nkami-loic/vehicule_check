import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://localhost:5000/api/auth';
  String? _authToken;
  String? _sessionId;

  String? get token => _authToken;
  String? get sessionId => _sessionId;

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      _authToken = responseBody['token'];
      _sessionId = responseBody['sessionId'];
      return true;
    } else {
      print('Login failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> register(String username, String password, String role) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      print('Registration successful');
      return true;
    } else {
      print('Registration failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchSessionData() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/test-session'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_authToken',
        'Cookie': 'connect.sid=$_sessionId',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load session data');
    }
  }
}
