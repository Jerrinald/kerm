import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

class ActorServices {
  static Future<Actor?> getMyActor({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/my-actor?kermesse_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 400) {
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return Actor.fromJson(data);
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while requesting stand with id kermesse $id');
    }
  }

  static Future<http.Response> updateActorJetonById(Actor actor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.patch(
        Uri.parse('${ApiEndpoints.baseUrl}/actors-jeton/${actor.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: json.encode(actor.toJson()),
      );

      print(response.statusCode);
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while updating event with id ${actor.id}',
            statusCode: response.statusCode);
      }

      return response;
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while updating event with id ${actor.id}');
    }
  }

  static Future<http.Response> updateActorActiveById(Actor actor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.patch(
        Uri.parse('${ApiEndpoints.baseUrl}/actors-active/${actor.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: json.encode(actor.toJson()),
      );

      print(response.statusCode);
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while updating event with id ${actor.id}',
            statusCode: response.statusCode);
      }

      return response;
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while updating event with id ${actor.id}');
    }
  }

  static Future<http.Response> addActor(Actor actor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/actors?kermesse_id=${actor.kermesseId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include token in headers
      },
      body: json.encode(actor.toJson()),
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

  static Future<List<ActorUser>> getActorWithMyKermesses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/actors-kermesse'),
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
        return ActorUser.fromJson(e);
      }).toList() ??
          [];
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }

}