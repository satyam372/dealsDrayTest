mport 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumbercontroller = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPhoneSelected = true;

  @override
  void initState() {
    super.initState();
    _phonenumbercontroller.addListener(_updateButtonState);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'lib/image/deals_dray_logo.jpg',
                  width: 200, // Icon size
                  height: 200,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSelection(true),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Glad to see you!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make text bold
                      fontSize: 28,
                      color: Colors.black, // Make text black
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please provide your phone number',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 30),
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

                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Colors.red : Colors.red[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _isButtonEnabled
                      ? () {

                  }
                      : null,
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                )])))));
  }
}
