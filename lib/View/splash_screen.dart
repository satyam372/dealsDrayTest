import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/View/login.dart';
import 'package:deals_dray_test/View/home_screen.dart';
import 'package:deals_dray_test/Domain/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late Services _services;

  @override
  void initState() {
    super.initState();
    _services = Services();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    bool isAuthenticated = await _services.sendToken();
      if (!isAuthenticated) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4.0, // Customize thickness if desired
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Customize color if desired
        ),
      ),
    );
  }
}
