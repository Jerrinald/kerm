import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

class StandServices {
  static Future<Stand> getMyStand({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/my-stand?kermesse_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 400) {
        return Stand(id: 0, actorId: 0, kermesseId: 0, type: "", maxPoint: 0, name: "");
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return Stand.fromJson(data);
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while requesting stand with id kermesse $id');
    }
  }

  static Future<Stand> getStandById({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/stands/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 400) {
        return Stand(id: 0, actorId: 0, kermesseId: 0, type: "", maxPoint: 0, name: "");
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return Stand.fromJson(data);
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while requesting stand with id kermesse $id');
    }
  }

  static Future<http.Response> addStand(Stand stand) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    print(stand.kermesseId);

    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/stands-kermesse'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include token in headers
      },
      body: json.encode(stand.toJson()),
    );

    print('status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;

  }

  static Future<List<Stand>> getStandsByKermesse({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/stands?kermesse_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      // Simulate call length for loader display
      await Future.delayed(const Duration(seconds: 1));

      if (response.statusCode < 200 || response.statusCode >= 400) {
        return [];
      }

      final data = json.decode(response.body);
      return (data as List<dynamic>?)?.map((e) {
        return Stand.fromJson(e);
      }).toList() ??
          [];
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }
}