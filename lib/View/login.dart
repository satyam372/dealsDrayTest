import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:deals_dray_test/Domain/login_send_otp.dart';
import 'package:deals_dray_test/View/otpVerification.dart';
import 'package:deals_dray_test/View/registration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumbercontroller = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPhoneSelected = true;
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
      _isButtonEnabled = textLength == 10;
    });
  }

  void _toggleSelection(bool isPhoneSelected) {
    setState(() {
      _isPhoneSelected = isPhoneSelected;
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
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSelection(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: _isPhoneSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Phone',
                            style: TextStyle(
                              color: _isPhoneSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _toggleSelection(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isPhoneSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: !_isPhoneSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    'Please provide your phone number',
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
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  maxLength: _isPhoneSelected ? 10 : null,
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
                  onPressed: _isButtonEnabled ? _sendOtp : null,
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
