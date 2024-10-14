import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/Api/login_send_otp.dart';
import 'package:deals_dray_test/View/otpVerification.dart';
import 'package:deals_dray_test/View/registration.dart';

// TODO:Redesign the screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumbercontroller = TextEditingController();
  bool _isButtonEnabled = false;
  final bool _isPhoneSelected = true;
  late Otp _otp;

  @override
  void initState() {
    super.initState();
    _phonenumbercontroller.addListener(_updateButtonState);
    _otp = Otp(onOtpSent: _handleOtpSent);
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


  void _handleOtpSent(int status) {
    if (status == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OtpVerificationScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    }
  }

  Future<void> _sendOtp() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final Map<String, dynamic> data = {
      "mobileNumber": _phonenumbercontroller.text,
      "deviceId": androidInfo.id,
    };
    await _otp.sendOtp(data);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OtpVerificationScreen()),
    );
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
                  onPressed: _sendOtp,
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                )])))));
  }
}
