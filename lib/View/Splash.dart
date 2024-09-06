import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/View/login.dart';
import 'package:deals_dray_test/Domain/Device_info.dart'; // Ensure this path is correct
import 'package:deals_dray_test/Api/services.dart'; // Import the Services class

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late DeviceInfo _deviceInfo; // Initialize the DeviceInfo variable
  late Services _services; // Declare Services instance

  @override
  void initState() {
    super.initState();
    _services = Services(); // Initialize Services instance (or use your dependency injection method)
    _deviceInfo = DeviceInfo(_services); // Pass Services instance to DeviceInfo
    _initializeDeviceInfo();
  }

  Future<void> _initializeDeviceInfo() async {
    await _deviceInfo.deviceInfo(); // Fetch device info asynchronously

    // Wait for 6 seconds or any delay you want
    Timer(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()), // Proper navigation to LoginScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'lib/image/splash.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
