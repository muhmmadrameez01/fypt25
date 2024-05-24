import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class NetworkHandler {
  final String baseUrl = "http://192.168.18.73:3300";
  final log = Logger();
  final storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    log.i('Token stored: $token');
  }

  Future<String?> getToken() async {
    String? token = await storage.read(key: 'auth_token');
    log.i('Retrieved token: $token');
    return token;
  }

  Future<void> clearToken() async {
    await storage.delete(key: 'auth_token');
    log.i('Token cleared');
  }

  Future<void> storeUsername(String username) async {
    await storage.write(key: 'username', value: username);
    log.i('Username stored: $username');
  }

  Future<String?> getUsername() async {
    String? username = await storage.read(key: 'username');
    log.i('Retrieved username: $username');
    return username;
  }

  Future<http.Response> get(String url) async {
    url = formatter(url);
    String? token = await getToken();
    log.i('Using token for GET: $token');

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    log.i(response.body);

    if (response.statusCode == 401) {
      log.i('GET request received 401 Unauthorized');
      await clearToken();
    }
    return response;
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formatter(url);
    log.d(body);

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    log.i(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('token')) {
        await storeToken(responseData['token']);
        if (responseData.containsKey('username')) {
          await storeUsername(responseData['username']);
        }
      }
    } else {
      log.i('POST request failed with status: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> updatepassword(
      String url, Map<String, String> body, String token) async {
    url = formatter(url);
    log.d(body);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    log.i(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('token')) {
        await storeToken(responseData['token']);
      }
    } else {
      log.i('POST request failed with status: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> postFormData(
      String url, Map<String, dynamic> data) async {
    url = formatter(url);
    log.d(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );

    return response;
  }

  Future<String?> getUsernameFromEmail(String email) async {
    String url = formatter('/user/username/$email');
    String? token = await getToken();
    log.i('Using token for GET username: $token');

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('username')) {
        return responseData['username'];
      } else {
        log.i('No username found in response');
      }
    } else {
      log.i('Failed to get username with status: ${response.statusCode}');
      if (response.statusCode == 401) {
        await clearToken();
      }
    }
    return null;
  }

  Future<String?> getUserNgoFromEmail(String email) async {
    String url = formatter('/ngo/ngoname/$email');
    String? token = await getToken();
    log.i('Using token for GET username: $token');

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('username')) {
        return responseData['username'];
      } else {
        log.i('No username found in response');
      }
    } else {
      log.i('Failed to get username with status: ${response.statusCode}');
      if (response.statusCode == 401) {
        await clearToken();
      }
    }
    return null;
  }

  Future<void> logout() async {
    await clearToken();
  }

  Future<void> updateUsername(
      String email, String newUsername, String token) async {
    final url = Uri.parse('$baseUrl/user/updateUsername');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include the token in the headers
    };
    final body = jsonEncode({'email': email, 'newUsername': newUsername});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Username successfully updated
        log.i('Username successfully updated');
      } else {
        // Failed to update username
        log.i('Failed to update username: ${response.body}');
      }
    } catch (e) {
      // Error handling
      log.i('Error updating username: $e');
    }
  }

  Future<void> updateNgoname(
      String email, String newUsername, String token) async {
    final url = Uri.parse('$baseUrl/user/updateUsername');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include the token in the headers
    };
    final body = jsonEncode({'email': email, 'newUsername': newUsername});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Username successfully updated
        log.i('Username successfully updated');
      } else {
        // Failed to update username
        log.i('Failed to update username: ${response.body}');
      }
    } catch (e) {
      // Error handling
      log.i('Error updating username: $e');
    }
  }

  Future<http.Response> register(String url, Map<String, String> body) async {
    url = formatter(url);
    log.d(body);

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    return response;
  }

  String formatter(String url) {
    return baseUrl + url;
  }

  Future<Map<String, dynamic>> requestOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/request-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyOtp(
      String email, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': json.decode(response.body)['message']
      };
    } else {
      return {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  Future<http.Response> checkEmail(String email) async {
    var response = await http.get(Uri.parse("$baseUrl/user/checkemail/$email"));
    return response;
  }

  Future<http.Response> submitFeedback(Map<String, String> data) async {
    var response = await http.post(
      Uri.parse("$baseUrl/support/feedback"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }
}
