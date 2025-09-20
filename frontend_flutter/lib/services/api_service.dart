import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiService {
  // ✅ Base URL dependendo da plataforma
  static final String baseUrl = kIsWeb
      ? "http://localhost:8000/api" // Flutter Web no host
      : Platform.isAndroid
      ? "http://10.0.2.2:8000/api" // Android Emulator
      : "http://localhost:8000/api"; // Windows / MacOS

  // Login
  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return response.body; // Pode conter token JWT
    } else {
      debugPrint('Login failed: ${response.statusCode} ${response.body}');
    }

    return null;
  }

  // Register
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) return true;

    debugPrint('Register failed: ${response.statusCode} ${response.body}');
    return false;
  }

  // List tasks
  static Future<List<String>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<String>.from(decoded.map((e) => e['title']));
    }

    throw Exception('Erro ao carregar tarefas: ${response.statusCode}');
  }

  // Create task
  static Future<String> createTask(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      body: {'title': title},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['title'];
    }

    throw Exception('Erro ao criar tarefa: ${response.statusCode}');
  }
}
