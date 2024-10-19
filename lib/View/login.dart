import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/Api/login_send_otp.dart';
import 'package:deals_dray_test/View/otpVerification.dart';
import 'package:deals_dray_test/View/registration.dart';
import 'package:deals_dray_test/Api/cloud_services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:deals_dray_test/View/homeScreen.dart';
import 'package:deals_dray_test/Domain/services.dart';

// TODO:Redesign the screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumbercontroller = TextEditingController();
  bool _isButtonEnabled = false;
  final bool _isPhoneSelected = true;
  late CloudServices _cloudServices;

  @override
  void initState() {
    super.initState();
    _phonenumbercontroller.addListener(_updateButtonState);
    _cloudServices = CloudServices();
  }

  @override
  void dispose() {
    _phonenumbercontroller.removeListener(_updateButtonState);
    _phonenumbercontroller.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final textLength = _phonenumbercontroller.text.length;
    setState(() {
      _isButtonEnabled = textLength == 14;
    });
  }
  // TODO:Shift the login to another file
  Future<void> sendData() async {
    final abc = encrypt.Key.fromSecureRandom(32);  // 32-byte AES key
    final encrypter = encrypt.Encrypter(encrypt.AES(abc, mode: encrypt.AESMode.ecb));
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final phonenumber = encrypter.encrypt(_phonenumbercontroller.text);  // No IV in ECB mode
    final device = encrypter.encrypt(androidInfo.id);
    final Map<String, dynamic> data = {
      "enrollment_no": phonenumber.base64,
      "device_id": device.base64,
      "token": '',
      "key": abc.base64,
    };
    final res = await _cloudServices.generateToken(data);
    if (res == true) {
      await storeValue('Enroll-no', _phonenumbercontroller.text);
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
      extendBody: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'lib/image/deals_dray_logo.jpg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Glad to see you!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please provide your Enrollment Number',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _phonenumbercontroller,
                  decoration: InputDecoration(
                    hintText: _isPhoneSelected ? 'Phone' : 'Email',
                  ),
                  keyboardType: _isPhoneSelected
                      ? TextInputType.text
                      : TextInputType.emailAddress,
                  maxLength: _isPhoneSelected ? 14 : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Colors.red : Colors.red[100],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: sendData,
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                )])))));
  }
}
