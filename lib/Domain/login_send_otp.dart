import 'dart:convert';
import 'package:dio/dio.dart';

class Otp {
  final void Function(int) onOtpSent; // Callback function

  Otp({required this.onOtpSent}); // Constructor

  Future<void> sendOtp(Map<String, dynamic> data) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://devapiv4.dealsdray.com/api/v2/user/otp',
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);

        // Extract status from the response data
        final int status = responseData['status'];

        // Call the callback with the status
        onOtpSent(status);
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }
}
