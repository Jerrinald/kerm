import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/models/statStand.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

class StatStandServices {

  static Future<http.Response> addStatStand(StatStand statStand) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/stand-statistics'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include token in headers
      },
      body: json.encode(statStand.toJson()),
    );

    if (response.statusCode == 201) {
      print('Succes: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create kermesse');
    }
  }
  
}