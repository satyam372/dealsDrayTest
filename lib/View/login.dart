import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:deals_dray_test/View/home_screen.dart';
import 'package:deals_dray_test/Domain/secure_storage.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController enrollmentnumbercontroller = TextEditingController();
  bool _isButtonEnabled = false;
  final storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    enrollmentnumbercontroller.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    enrollmentnumbercontroller.removeListener(_updateButtonState);
    enrollmentnumbercontroller.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final textLength = enrollmentnumbercontroller.text.length;
    setState(() {
      _isButtonEnabled = textLength == 14;
    });
  }

  Future<void> sendData() async {
    final key = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final encryptedEnrollNumber = encrypter.encrypt(enrollmentnumbercontroller.text, iv: iv);
    encrypter.encrypt(androidInfo.id, iv: iv);
    try {
      await storage.storeValue('Enroll-no', encryptedEnrollNumber.base64);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/image/icon3.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your Enrollment Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: enrollmentnumbercontroller,
                  decoration: InputDecoration(
                    hintText: 'Enrollment Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 14,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Colors.redAccent : Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _isButtonEnabled ? sendData : null,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ))])))));
  }
}
