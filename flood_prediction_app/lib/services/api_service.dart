import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // Dynamic base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000'; // Use localhost for web
    } else {
      return 'http://10.0.2.2:8000'; // For Android emulator
    }
  }

  static Future<Map<String, dynamic>> predictFlood(Map<String, int> inputData) async {
    try {
      print('Sending request to: ${baseUrl}/predict');
      print('Request data: ${jsonEncode(inputData)}');
      
      final response = await http.post(
        Uri.parse('${baseUrl}/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['detail'] ?? 'Failed to get prediction');
      }
    } catch (e) {
      print('API error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }
}