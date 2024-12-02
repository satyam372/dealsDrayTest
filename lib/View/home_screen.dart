import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:screen_protector/screen_protector.dart';
import 'package:deals_dray_test/Domain/secure_storage.dart';
import 'package:deals_dray_test/Domain/encryption.dart';

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
  String encryptedQrData = '';

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
      encryptedQrData = encryptData(qrData) as String; // TODO:Change the type of var to accept encrypted value
    }
    setState(() {
      encryptedQrData;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Center the QR code and increase its size
            Container(
              height: 300, // Increased size for larger QR display
              width: 300, // Keep width and height the same for square shape
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: encryptedQrData.isEmpty
                    ? Text(
                  'QR Code Expired',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                )
                    : QrImageView(data: encryptedQrData, size: 280),
              ),
            ),
            const SizedBox(height: 30), // Space between QR and button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isButtonLocked ? null : generateQr,
                child: Text(
                  isButtonLocked
                      ? "Valid for 30sec only"
                      : "Generate QR Code",
                  style: TextStyle(
                    color: isButtonLocked ? Colors.grey : Colors.indigo[900],
                  ))))])));
  }
}
