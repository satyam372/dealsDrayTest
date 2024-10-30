import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:deals_dray_test/Domain/secure_storage.dart';

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://192.168.225.224:8000'
  );
}

class CloudServices {
  final storage = SecureStorage();
  Future<bool> findUser(Map<String, dynamic> data) async {
    bool found = false;
    final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
    try {
      final response = await dio.post(
        'http://192.168.225.224:8000/register/',
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final token = responseData['token'];
        if (token == null || token.toString().isEmpty) {
          throw Exception('Invalid token received');
        }
        await storage.storeValue('auth-token', token);
        final result = await storage.getValue('auth-token');
        print('ofnjnj:$result');
        found = true;
      }
    } catch (e) {
      found = false;
    }
    return found;
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
            "Accept": "application/json",
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

  Future<bool> sendToken() async {
    try {
      final token = await storage.getValue('auth-token');
      if (token == null) {
        return false;
      }
      final isValid = await validateToken(token);
      return isValid;
    } catch (e) {
      return false;
    }
  }
}
