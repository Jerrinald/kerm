import 'dart:convert';
import 'dart:developer';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

class PaiementServices {
  static Future<String> getPaiement({required int nbJeton}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/payment_intent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: json.encode({
          'nbJeton': nbJeton, // Pass the number of tickets
        }),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final clientSecret = body['clientSecret'];
        return clientSecret;
      } else {
        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (error) {
      log('Error occurred while retrieving payment.', error: error);
      throw Exception('Error occurred during payment process.');
    }
  }
}
