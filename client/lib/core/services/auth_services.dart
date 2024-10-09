import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static Future<http.Response> registerUser(User user) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/register');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'
    };
    final body = jsonEncode(<String, String>{
      'firstname': user.firstname,
      'lastname': user.lastname,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'role': user.role,
    });

    log('Registering user at $uri with body: $body');

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to register user');
    }
  }


  static Future<http.Response> registerKid(User user) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');


    final uri = Uri.parse('${ApiEndpoints.baseUrl}/register-kid');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token', // Include token in headers
    };
    final body = jsonEncode(<String, String>{
      'firstname': user.firstname,
      'lastname': user.lastname,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'role' : user.role
    });

    log('Registering kid at $uri with body: $body');

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Vérification et journalisation du contenu de la réponse JSON
      Map<String, dynamic> responseJson;
      try {
        responseJson = jsonDecode(response.body);
      } catch (e) {
        log('Error decoding JSON: $e');
        throw Exception('Failed to decode JSON');
      }

      // Vérification de la présence du token
      if (responseJson.containsKey('token') &&
          responseJson['token'] is String) {
        String token = responseJson['token'];
        log('Token received: $token');
      } else {
        log('Token is missing or is not a string');
        throw Exception('Failed to retrieve token');
      }
      return response;
    } else {
      log('Failed to login, status code: ${response.statusCode}');
      throw Exception('Failed to login');
    }
  }


  static Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}