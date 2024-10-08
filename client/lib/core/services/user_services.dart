import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

class UserServices {
  static Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.https(ApiEndpoints.baseUrl, '/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      // Simulate call length for loader display
      await Future.delayed(const Duration(seconds: 1));

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw Error();
      }

      final data = json.decode(response.body);
      return (data as List<dynamic>?)?.map((e) {
        return User.fromJson(e);
      }).toList() ??
          [];
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }

  static Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/my-user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while retrieving current user',
            statusCode: response.statusCode);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(data);
    } catch (error) {
      log('Error occurred while retrieving current user.', error: error);
      throw ApiException(message: 'Unknown error while retrieving current user');
    }
  }

  static Future<http.Response> registerUserAdmin(User user) async {
    final response = await http.post(
      Uri.https(ApiEndpoints.baseUrl, '/registerAdmin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': user.firstname,
        'lastname': user.lastname,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'password': user.password, // Add password to the User model
      }),
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<User> getCurrentUserByEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    try {
      final response = await http.get(
        Uri.https(ApiEndpoints.baseUrl, '/users-email/$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while requesting event with email $email',
            statusCode: response.statusCode);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(data);
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while requesting product with email $email');
    }
  }

  static Future<List<User>> getUsersParticipants({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Fetch participants for the given event ID
      final response = await http.get(
        Uri.https(ApiEndpoints.baseUrl, '/participants-event/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw Exception('Failed to load participants');
      }

      // Decode the participants data
      final List<dynamic> participantsData = json.decode(response.body);

      // Initialize a list to hold User objects
      List<User> users = [];

      // Fetch user data for each participant
      for (var participantData in participantsData) {
        final int userId = participantData['user_id'];
        final userResponse = await http.get(
          Uri.https(ApiEndpoints.baseUrl, '/users/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token', // Include token in headers
          },
        );
        if (userResponse.statusCode < 200 || userResponse.statusCode >= 400) {
          throw Exception('Failed to load user with ID $userId');
        }

        // Decode the user data and add to the users list
        final userData = json.decode(userResponse.body);
        users.add(User.fromJson(userData));
      }
      // Simulate call length for loader display
      await Future.delayed(const Duration(seconds: 1));
      return users;
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }

  static Future<List<User>> getUsersParticipantsContribution({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Fetch participants for the given event ID
      final response = await http.get(
        Uri.https(ApiEndpoints.baseUrl, '/participants-contribution/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw Exception('Failed to load participants');
      }

      // Decode the participants data
      final List<dynamic> participantsData = json.decode(response.body);

      // Initialize a list to hold User objects
      List<User> users = [];

      // Fetch user data for each participant
      for (var participantData in participantsData) {
        final int userId = participantData['user_id'];
        final userResponse = await http.get(
          Uri.https(ApiEndpoints.baseUrl, '/users/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token', // Include token in headers
          },
        );
        if (userResponse.statusCode < 200 || userResponse.statusCode >= 400) {
          throw Exception('Failed to load user with ID $userId');
        }

        // Decode the user data and add to the users list
        final userData = json.decode(userResponse.body);
        users.add(User.fromJson(userData));
      }
      // Simulate call length for loader display
      await Future.delayed(const Duration(seconds: 1));
      return users;
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }



  static Future<User> getUser({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.https(ApiEndpoints.baseUrl, '/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while requesting user with id $id',
            statusCode: response.statusCode);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(data);
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while requesting user with id $id');
    }
  }

  static Future<http.Response> updateUserById(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.patch(
        Uri.https(ApiEndpoints.baseUrl, '/users/${user.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while updating user with id ${user.id}',
            statusCode: response.statusCode);
      }

      return response;
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while updating user with id ${user.id}');
    }
  }

  static Future<void> deleteUserById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.https(ApiEndpoints.baseUrl, '/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
            message: 'Error while deleting user with id $id',
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException(
          message: 'Unknown error while deleting user with id $id');
    }
  }


  static Future<List<User>> getUsersWiThParent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/users-parent'),
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
        return User.fromJson(e);
      }).toList() ??
          [];
    } catch (error) {
      log('Error occurred while retrieving users.', error: error);
      rethrow;
    }
  }
}
