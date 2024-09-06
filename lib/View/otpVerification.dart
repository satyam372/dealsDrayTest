import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'login.dart'; // Add sms_autofill package for OTP autofill

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> with CodeAutoFill {
  final TextEditingController otpController = TextEditingController();
  int _timerCountdown = 117; // Set 1 minute 57 seconds timer
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    listenForCode(); // Start listening for SMS OTP
    _startTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    cancel(); // Stop listening for OTP when the screen is disposed
    super.dispose();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCountdown > 0) {
          _timerCountdown--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void codeUpdated() {
    setState(() {
      otpController.text = code!;
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_timerCountdown ~/ 60).toString().padLeft(2, '0');
    String seconds = (_timerCountdown % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back button
            // Phone image
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
            child: Image.asset(
              'lib/image/otpVerification.jpg',
              height: 100,
            ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
            child: Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
            child: Text(
              "We have sent a unique OTP number\nto your mobile 000000", // TODO:- Replace with actual phone number
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            ),
            SizedBox(height: 20),
            PinFieldAutoFill(
              codeLength: 4, // OTP length
              controller: otpController,
              decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$minutes : $seconds",
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                  onPressed: _isResendEnabled
                      ? () {
                    _startTimer(); // Resend OTP and reset timer
                  }
                      : null,
                  child: Text(
                    "SEND AGAIN",
                    style: TextStyle(
                      color: _isResendEnabled ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
