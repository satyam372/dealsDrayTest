import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:deals_dray_test/Domain/services.dart';

class CloudServices {

  Future<bool> generateToken(Map<String, dynamic> data) async {
    bool send = false;
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://192.168.225.224:8000/register/',
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
        await storeValue('auth-token', token);
        send = true;
      }
    } catch (e) {
      send = false;
    }
    return send;
  }

  Future<bool> validateToken(String data)async {
    bool isValid = false;
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://192.168.225.224:8000/verify-token/',
        data: jsonEncode({"token": data}),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
    );
      if (response.statusCode == 200) {
        isValid = true;
      }
    }
    catch(e) {
      isValid = false;
    }
    return isValid;
  }
}
