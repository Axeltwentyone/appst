import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";
  // 10.0.2.2 = localhost de ton Mac depuis l'émulateur Android

  // LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      return true;
    }

    return false;
  }

  // REGISTER
  static Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    return response.statusCode == 200;
  }

  // GET USER (route protégée)
  static Future<http.Response> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    return await http.get(
      Uri.parse("$baseUrl/user"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    await http.post(
      Uri.parse("$baseUrl/logout"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    await prefs.remove("token");
  }
}
