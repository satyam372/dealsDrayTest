import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/View/login.dart';
import 'package:deals_dray_test/View/homeScreen.dart';
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
        child: Image.asset(
          'lib/image/splash.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
