import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:screen_protector/screen_protector.dart';
import 'package:deals_dray_test/Domain/secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String qrData = '';
  DateTime? lastGeneratedTime;
  bool isButtonLocked = false;
  final storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    ScreenProtector.preventScreenshotOn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> generateQr() async{
    await ScreenProtector.preventScreenshotOn();
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
    String? rollNumber = await storage.getValue('Enroll-no');
    if (rollNumber != null) {
      qrData = rollNumber + formattedTime;
    }
    setState(() {
      qrData;
      lastGeneratedTime = currentTime;
      isButtonLocked = true;
    });
    Timer(const Duration(seconds: 30), () {
      setState(() {
        isButtonLocked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              if (qrData.isNotEmpty)
                QrImageView(data: qrData),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                onPressed: isButtonLocked
                      ? null
                      : () {
                    generateQr();
                  },
                  child: Text(
                    isButtonLocked
                        ? "Please wait before generating a new QR"
                        : "Generate QR Code",
                    style: TextStyle(
                      color: isButtonLocked ? Colors.grey : Colors.indigo[900],
                    ))))]))));
  }
}
