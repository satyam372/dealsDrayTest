import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:deals_dray_test/View/login.dart';
import 'package:flutter/cupertino.dart';

class Services {
  late LoginScreen _loginScreen;

  Future<void> sendDeviceInfo(Map<String, dynamic> data) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://devapiv4.dealsdray.com/api/v2/user/device/add',
        data: jsonEncode(data),
        // No need for a loop, just serialize the entire data
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Device info sent successfully");
      } else {
        print("Failed to send device info: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending device info: $e");
    }
  }


}