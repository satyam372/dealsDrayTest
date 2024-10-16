import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp {
  final void Function(int) onOtpSent; // Callback function
  Otp({required this.onOtpSent}); // Constructor

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Retrieve token
  }

  Future<bool> sendOtp(Map<String, dynamic> data) async {
    bool send = false;
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://192.168.225.224:8000/validate/',
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final token = responseData['token'];
        await _storeToken(token);
        send = true;
      }
    } catch (e) {
      send = false;
    }
    return send;
  }
}